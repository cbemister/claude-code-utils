# [PROJECT_NAME]

> Replace all `[PLACEHOLDER]` values throughout this file before using.

## Overview

**Project:** [PROJECT_NAME]
**Type:** [e.g., SaaS web application / REST API / internal tool]
**Stack:** [e.g., Next.js 14 + TypeScript + PostgreSQL + Tailwind]
**Team:** [Team name or size]

[1-2 sentences describing what this project does and who it's for.]

## Key Commands

```bash
# Install dependencies
[install command]

# Start development server
[dev command]

# Run tests
[test command]

# Run tests with coverage
[test coverage command]

# Lint and format
[lint command]

# Build for production
[build command]

# Database migrations
[migration command]
```

## Project Structure

> See `.claude/rules/architecture.md` for full architecture documentation.

```
[YOUR_PROJECT]/
├── .claude/
│   ├── agents/         # Enterprise agent team (8 specialists)
│   └── rules/          # Project knowledge base (keep updated!)
├── plans/
│   ├── active/         # Current work in progress
│   ├── archive/        # Completed plans
│   └── templates/      # Plan templates
├── [src/ or app/]      # Application source
└── CLAUDE.md           # This file
```

## Agent Team

This project uses a specialized enterprise agent team. Agents read `.claude/rules/` to understand the codebase before making decisions.

| Agent | When to Use |
|---|---|
| `coordinator` | Complex multi-layer tasks, parallel work coordination |
| `backend-architect` | APIs, database changes, service layer |
| `frontend-architect` | UI components, pages, state management |
| `security-auditor` | Before merging any auth/permission changes |
| `test-engineer` | Adding test coverage, TDD setup |
| `devops-engineer` | CI/CD, deployment, infrastructure |
| `code-reviewer` | Pre-merge review, quality checks |
| `performance-analyst` | Slow queries, bundle analysis, scaling |

### Recommended Workflows

**New feature:**
```
coordinator → backend-architect + frontend-architect → security-auditor → test-engineer → code-reviewer
```

**Bug fix:**
```
debugger → [backend/frontend]-architect → test-engineer (regression)
```

**Pre-launch:**
```
security-auditor + performance-analyst (parallel) → code-reviewer
```

## Rules System

`.claude/rules/` contains project-specific knowledge that agents use automatically. **Keep these files updated** — stale rules cause incorrect suggestions.

| File | Contents |
|---|---|
| `architecture.md` | System design, layer boundaries, key decisions |
| `api-conventions.md` | Endpoint patterns, request/response shapes |
| `security-policy.md` | Auth requirements, validation rules, secrets policy |
| `code-standards.md` | Naming, patterns, what to avoid |
| `testing-standards.md` | Coverage targets, test framework, conventions |
| `env.md` | All environment variables |

## Development Workflow

### Session Start
```
1. Check plan status: /plan-status
2. Read session notes: ~/.claude/projects/[project-slug]/memory/sessions/
3. Start on the highest-priority task in the active plan
```

### During Development
```
- Use /worktree-create for features that need isolation
- Commit frequently with conventional commit messages
- Run tests before moving to the next task
```

### Session End
```
1. Run /summarize-session to capture context for next session
2. Run /ship for the end-of-session workflow (verify → commit → track)
```

### Context Across Threads

For long-running work spanning multiple sessions:
1. Create a context handoff: copy `plans/templates/context-handoff.md`, fill it out
2. Paste the filled-out handoff at the start of the next Claude Code session
3. The `summarize-session` skill writes to `~/.claude/projects/[project-slug]/memory/sessions/` automatically

## Code Quality Standards

> See `.claude/rules/code-standards.md` for the full standards document.

- All PRs require passing CI (lint + tests + types)
- PRs must have at least 1 code review approval
- Authentication/authorization changes require `security-auditor` sign-off
- Coverage must not drop below the target in `.claude/rules/testing-standards.md`

## Plugin Marketplace

This project's agent team is published as a Claude Code plugin. To install in another project:

```bash
# After pushing marketplace.json to GitHub:
/plugin marketplace add [owner]/[repo]
```

To validate the marketplace.json before publishing:
```bash
claude plugin validate .
```

See `marketplace.json` for the plugin catalog configuration.

## MCP Servers

Optional MCP integrations are configured in `.mcp.json`. Requires the matching environment variables from `.claude/rules/env.md`.

To enable: set the required env vars, then restart Claude Code.

## Security Requirements

> See `.claude/rules/security-policy.md` for the complete security policy.

- Never commit secrets — use `.env.local` locally, secret store in CI/CD
- Run `security-auditor` agent before merging any auth or permission change
- Input validation is required on all API endpoints
- Review `.claude/rules/security-policy.md` before implementing auth features

## Hooks

`.claude/settings.json` includes pre-configured safety hooks:
- **Secret scan**: Warns if common secret patterns are detected in files being written
- **Auto-format**: Runs Prettier/Black on save if config files are present
- **TypeScript check**: Runs `tsc --noEmit` on `.ts` / `.tsx` files after editing
- **Bash protection**: Blocks dangerous shell patterns (`rm -rf`, `curl | bash`, force push)
