# CodeForge Slack Bot — Design Spec

## Problem

The software factory pipeline (launch → build → evolve) currently requires the CLI for all interactions. Notifications go out via Slack webhooks, but commands and approvals must happen at the terminal. This means:

- Evolution gates (approve/reject preview deploys) require being at the computer
- No way to trigger builds or check status from a phone
- No interactive feedback — just one-way notification messages

## Solution

A Slack Bolt app running locally that turns the existing CodeForge Slack app into a full control plane for the software factory. Slack replaces the CLI as the primary interface for managing builds, evolution cycles, and factory status.

## Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Framework | Slack Bolt (Node.js) | Full interactivity (buttons, slash commands, threads), well-documented, TypeScript support |
| Connection | Socket Mode | No public URL needed, works behind NAT/firewall, zero hosting cost |
| Runtime | Local process on dev machine | Zero cost, direct filesystem access, can spawn child processes |
| Location | `scripts/factory-bot/` in claude-code-utils | Single repo for the whole factory |
| Slack app | Upgrade existing CodeForge | Reuse webhook, one app to manage |
| Execution | Direct child processes | Immediate, full control, can stream progress |
| Notification coexistence | Bot disables runner webhooks when active | No double-posting; runners fall back to webhooks when bot is off |

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Slack (CodeForge app)                │
│  Slash commands, buttons, threads, notifications        │
└──────────────────────┬──────────────────────────────────┘
                       │ Socket Mode (WebSocket)
                       │
┌──────────────────────▼──────────────────────────────────┐
│              scripts/factory-bot/                        │
│                                                          │
│  index.ts          — Bolt app, slash command routing     │
│  commands/         — Handler per command                 │
│    launch.ts       — Spawn claude --print for launch    │
│    build.ts        — Spawn build-app-runner.sh          │
│    evolve.ts       — Spawn evolution-runner.sh          │
│    status.ts       — Read state files, format, post     │
│    list.ts         — Read registry.json, format         │
│    approve.ts      — Write evolution gate + resume      │
│    reject.ts       — Write evolution gate + resume      │
│  lib/                                                    │
│    state-reader.ts — Parse build-state.json & evo state │
│    process-mgr.ts  — Spawn/track child processes        │
│    slack-fmt.ts    — Format messages with blocks/buttons│
│    file-watcher.ts — Watch state files for changes      │
│  config.ts         — Load env vars                      │
│  package.json                                            │
│  tsconfig.json                                           │
└──────────────────────┬──────────────────────────────────┘
                       │ child_process.spawn()
                       │
┌──────────────────────▼──────────────────────────────────┐
│  Existing scripts (unchanged)                            │
│    build-app-runner.sh                                   │
│    evolution-runner.sh                                   │
│                                                          │
│  State files (read by bot for updates)                   │
│    plans/build-state.json                                │
│    factory/evolution-state.json                          │
│    factory/registry.json                                 │
└─────────────────────────────────────────────────────────┘
```

The bot is a thin bridge. The runner scripts do all real work — the bot spawns them, watches their state files, and posts updates to Slack.

## Slack Commands

Single slash command with subcommand routing:

| Command | Action | Response Type |
|---------|--------|---------------|
| `/factory launch <idea>` | Spawn `claude --print -p "/factory launch <idea>"` in claude-code-utils dir | Thread with progress |
| `/factory build <project>` | Spawn `build-app-runner.sh <project-path>` | Thread with per-stage updates |
| `/factory evolve <project>` | Spawn `evolution-runner.sh <project-path>` | Thread with per-cycle updates |
| `/factory status [project]` | Read state files, format summary | Ephemeral message |
| `/factory list` | Read `factory/registry.json` | Ephemeral message |

## Interactive Buttons

Attached to notification messages, eliminating the need for CLI commands:

| Context | Buttons | Action |
|---------|---------|--------|
| Evolution gate (preview deployed) | Approve / Reject | Write to `factory/evolution-state.json`, re-spawn evolution-runner |
| Build failed | Resume / View Error | Run `/build-app resume` via runner, or post error detail |
| Stage complete | View Preview | Link button to preview URL (no backend action) |
| Build complete | Start Evolution | Trigger `/factory evolve` for the project |

## Threaded Progress Updates

Each `/factory build` or `/factory evolve` creates a parent message. Progress is posted as thread replies.

**Mechanism:** `fs.watch()` on state files with 1-second debounce. On change, read new state, diff against last snapshot, post only what changed.

| State change | Thread message |
|-------------|----------------|
| Task completed | `Task 0A: Scaffold Next.js ✓ (abc123)` |
| Stage started | `Stage 1: Task Tracker — 5 tasks` |
| Stage complete | `Stage 1 complete — Preview: <url>` |
| Verification passed | `Stage checkpoint: all criteria passed` |
| Task failed (retrying) | `Task 1C failed — retrying (2/3)` |
| Build/evolution complete | `Build complete — 2 stages, 8 commits` |
| Human gate reached | Message with Approve/Reject buttons |

The parent message is edited to show current status (e.g., "Building Stage 1... (3/5 tasks)") so the channel always shows latest state at a glance.

## Process Management

```typescript
interface ManagedProcess {
  projectName: string;
  type: 'build' | 'evolve' | 'launch';
  process: ChildProcess;
  threadTs: string;       // Slack thread to post updates to
  channelId: string;
  startedAt: Date;
  stateFile: string;      // path to watch
}
```

**Rules:**
- One active process per project (can't build and evolve the same project simultaneously)
- Multiple projects can run in parallel (build project A while evolving project B)
- If the bot restarts, it reads state files to detect orphaned processes and posts catch-up summary
- Runner scripts handle their own restartability — bot just re-spawns them

**`launch` is special:** Spawns `claude --print -p "/factory launch <idea>"` with `--dangerously-skip-permissions` since it runs non-interactively.

## Notification Coexistence

The runner scripts currently send their own Slack notifications via webhook/curl. With the bot:

- **Bot running** → bot sets `SLACK_WEBHOOK_URL=""` when spawning runners, handles all Slack communication (rich, interactive, threaded)
- **Bot not running** → runner scripts use webhooks directly (basic, one-way, works as before)
- **Zero changes** to the runner scripts themselves

## CodeForge App Setup

The existing CodeForge app (currently webhook-only) needs these additions:

1. **Socket Mode** — App-Level Token with `connections:write` scope
2. **Slash command** — `/factory` pointing to the app
3. **Interactivity** — enable for button callbacks
4. **Bot token scopes** — `chat:write`, `commands`

### Configuration

Bot config via `scripts/factory-bot/.env`:

```bash
SLACK_BOT_TOKEN=xoxb-...          # Bot User OAuth Token
SLACK_APP_TOKEN=xapp-...          # App-Level Token (Socket Mode)
SLACK_SIGNING_SECRET=...          # Request verification
FACTORY_ROOT=/c/Users/cbemister/Development/claude-code-utils
SLACK_CHANNEL=#codeforge          # Default notification channel
```

### Running

```bash
# Development
npx tsx scripts/factory-bot/index.ts

# Production (compiled)
node scripts/factory-bot/dist/index.js

# Background service
pm2 start scripts/factory-bot/dist/index.js --name codeforge
```

### Dependencies

```json
{
  "name": "codeforge-bot",
  "private": true,
  "type": "module",
  "dependencies": {
    "@slack/bolt": "^4.1.0"
  },
  "devDependencies": {
    "typescript": "^5.x",
    "tsx": "^4.x"
  }
}
```

## Error Handling

| Scenario | Handling |
|----------|---------|
| Bot crashes mid-build | Runner keeps going (child process). On restart, bot reads state and posts catch-up |
| Runner crashes | Bot detects process exit, posts failure to thread, offers Resume button |
| Rate limit hit | Runner handles backoff internally. Bot sees state stall, posts "rate limited, waiting..." |
| Duplicate command | Bot checks process map, responds "already building project X" |
| Unknown project | Bot reads registry, posts "not found — did you mean X?" |
| Machine sleeps/wakes | Runner resumes from state file on next invocation. Bot posts "resumed after pause" |
| Slack disconnects | Bolt auto-reconnects Socket Mode. Missed state changes caught on reconnect via file read |

## Testing Plan

1. **Unit tests** — state-reader parses real state file fixtures, slack-fmt produces correct block structures
2. **Integration test** — spawn a mock runner script that writes state changes, verify bot posts correct thread updates
3. **Manual E2E** — run `/factory build task-tracker` from Slack, verify full lifecycle with task-tracker test project

## Out of Scope (Future)

- Cloud execution (GitHub Actions dispatch from Slack) — add later with `/factory build --cloud`
- Multi-user access control — currently single-user
- Persistent bot state (database) — file-based is sufficient for single machine
- Slack Home tab with dashboard — nice-to-have after core commands work
