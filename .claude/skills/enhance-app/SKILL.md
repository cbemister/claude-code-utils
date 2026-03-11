---
name: enhance-app
description: Enhance an existing project with Claude Code agents, teams, rules, hooks, plans, MCP servers, and CLAUDE.md. Scans what exists, installs what's missing. Links shared files (agents, plan templates) from ~/.claude/shared/enterprise/ instead of duplicating.
---

# Enhance App

Enhance an existing project with Claude Code configuration. Shared files (agents, plan templates) are linked from a central location — not duplicated per project.

## Instructions

**IMPORTANT: Non-interactive where possible. Complete all steps without pausing unless a decision is required.**

### Step 1: Pre-flight Check & Scan Existing Config

1. If not a git repo, initialize one: `git init`
2. Survey what the project already has:

```bash
echo "=== Existing Configuration ==="
[ -d .claude/agents ] && echo "  Agents:      $(ls .claude/agents/*.md 2>/dev/null | wc -l) files" || echo "  Agents:      (none)"
[ -d .claude/rules ] && echo "  Rules:       $(ls .claude/rules/*.md 2>/dev/null | wc -l) files" || echo "  Rules:       (none)"
[ -f .claude/settings.json ] && echo "  Settings:    exists" || echo "  Settings:    (none)"
[ -d plans ] && echo "  Plans:       exists" || echo "  Plans:       (none)"
[ -f CLAUDE.md ] && echo "  CLAUDE.md:   exists ($(wc -l < CLAUDE.md) lines)" || echo "  CLAUDE.md:   (none)"
[ -f .mcp.json ] && echo "  MCP:         exists" || echo "  MCP:         (none)"
[ -f marketplace.json ] && echo "  Marketplace: exists" || echo "  Marketplace: (none)"
```

### Step 2: Auto-detect Project Details

Auto-detect as much as possible before asking the user anything:

```bash
PROJECT_NAME=$(basename "$PWD")
cat package.json 2>/dev/null
cat README.md 2>/dev/null | head -30
cat Cargo.toml 2>/dev/null
cat go.mod 2>/dev/null
cat pyproject.toml 2>/dev/null
```

From these files, infer:
- **PROJECT_NAME** — from directory name or package.json `name`
- **STACK** — from dependencies (e.g., `next` -> "Next.js + TypeScript")
- **PROJECT_TYPE** — from STACK + README context (web app, API, CLI, library)
- **DESCRIPTION** — from package.json `description` or first line of README
- **CMD_INSTALL / CMD_DEV / CMD_TEST / CMD_BUILD / CMD_LINT** — from package.json `scripts`

Detect the package manager:
```bash
[ -f bun.lockb ] && PM="bun" || { [ -f pnpm-lock.yaml ] && PM="pnpm" || { [ -f yarn.lock ] && PM="yarn" || PM="npm"; }; }
```

**Present a single confirmation** with everything pre-filled:

```
Auto-detected project configuration:

  Project name:  [detected]
  Project type:  [detected]
  Tech stack:    [detected]
  Description:   [detected]
  Install:       [detected]  Dev: [detected]  Test: [detected]
  Build:         [detected]  Lint: [detected]

Press Enter to accept, or type corrections (e.g., "type: SaaS dashboard, description: ...")
```

Only ask for values that genuinely could not be detected. For anything with a reasonable default, use it without asking.

Store as variables:
- PROJECT_NAME, PROJECT_TYPE, STACK, DESCRIPTION, TEAM
- CMD_INSTALL, CMD_DEV, CMD_TEST, CMD_BUILD, CMD_LINT

### Step 2.5: Team Selection

Read `teams/teams.json` from the template directory (found in Step 3, or check the known locations now). Present the available teams:

```
Available agent teams:

  1. Enterprise Engineering (default)
     7 agents: backend, frontend, security, test, devops, review, perf
     Best for: Complex apps, internal tools

  2. SaaS Product
     8 agents: + ui-ux-designer, conversion-optimizer
     Best for: SaaS products, dashboards, subscription products

  3. Internal Tool
     8 agents: + ui-ux-designer (practical focus)
     Best for: Admin panels, developer tools, back-office apps

  4. Game / Interactive
     6 agents: + ui-ux-designer, mobile-designer
     Best for: Games, interactive experiences, creative tools

  5. Marketing Site
     6 agents: + all 3 designers, frontend only
     Best for: Landing pages, marketing sites, pricing pages

Select a team (1-5, default 1):
```

Store the selection as `TEAM_ID` (one of: `enterprise`, `saas-product`, `internal-tool`, `game-interactive`, `marketing-site`).
Store the team's display name as `TEAM_DISPLAY_NAME`.
Store the team's agent list from teams.json as `TEAM_AGENTS`.

### Step 3: Find Shared Source

Locate the shared enterprise files. Check these locations in order:

**For agents and plan templates (shared — linked, not copied):**
1. `~/.claude/shared/enterprise/agents/` and `~/.claude/shared/enterprise/plan-templates/`
2. `~/.claude/skills/enhance-app/templates/enhance-app/.claude/agents/` and `.../plans/templates/`
3. The claude-code-utils repo: `templates/enhance-app/` relative to the skill location

Store as `SHARED_AGENTS_DIR` and `SHARED_PLANS_DIR`.

**For team coordinators (team-specific):**
1. `~/.claude/shared/enterprise/teams/$TEAM_ID/coordinator.md`
2. `~/.claude/skills/enhance-app/templates/enhance-app/teams/$TEAM_ID/coordinator.md`
3. The claude-code-utils repo: `templates/enhance-app/teams/$TEAM_ID/coordinator.md`

Store as `TEAM_COORDINATOR_PATH`.

**For templates that need per-project customization (rules, CLAUDE.md, hooks, etc.):**
1. `~/.claude/skills/enhance-app/templates/enhance-app/`
2. The claude-code-utils repo: `templates/enhance-app/` relative to the skill location

Store as `TEMPLATE_DIR`.

If nothing found, print an error with instructions to install from the claude-code-utils repository.

### Step 4: Link Shared Files (Team Agents + Plan Templates)

**These files are identical across projects — link them, don't copy.**

Create the project directories:
```bash
mkdir -p .claude/agents plans/templates
```

**Link each agent file** from the shared source. Use hardlinks on Windows, symlinks on Unix. Skip files that already exist in the project.

**IMPORTANT — Windows (Git Bash / MSYS) hardlink quirk:**
`cmd //c mklink /H` requires unquoted literal Windows-style paths. Variable interpolation
with backslashes breaks in Git Bash. Use `cmd //c "mklink /H <literal-target> <literal-source>"`
where paths have NO surrounding quotes and NO shell variable expansion with backslashes.

For each file, run an individual `cmd //c mklink /H` command with the full literal Windows path:

```bash
# Example for a single agent file:
cmd //c "mklink /H C:\Users\chris\ProjectDir\.claude\agents\coordinator.md C:\Users\chris\.claude\shared\enterprise\agents\coordinator.md"
```

**On Unix**, use symlinks:
```bash
ln -s "$SHARED_AGENTS_DIR/coordinator.md" ".claude/agents/coordinator.md"
```

**Fallback:** If hardlink/symlink fails, copy the file instead.

#### 4a: Link the team-specific coordinator

Link the coordinator from `$TEAM_COORDINATOR_PATH` (the team-specific coordinator for the selected `$TEAM_ID`):

```bash
target=".claude/agents/coordinator.md"
[ -f "$target" ] || link_or_copy "$TEAM_COORDINATOR_PATH" "$target"
```

#### 4b: Link only the agents in the selected team

Read the `TEAM_AGENTS` list from `teams.json` for the selected `$TEAM_ID`. Only link agents that appear in this list — do NOT link all agents from the pool:

```bash
# Link only the agents listed in the selected team's "agents" array
for agent_name in $TEAM_AGENTS; do
  source="$SHARED_AGENTS_DIR/${agent_name}.md"
  target=".claude/agents/${agent_name}.md"
  [ -f "$source" ] || continue
  [ -f "$target" ] && continue  # skip existing
  # On Windows: use cmd //c mklink /H with literal Windows paths (see note above)
  # On Unix: ln -s "$source" "$target"
  # Fallback: cp "$source" "$target"
done
```

#### 4c: Link plan template files (same for all teams)

```bash
for template_file in "$SHARED_PLANS_DIR"/*.md; do
  [ -f "$template_file" ] || continue
  link_file "$template_file" "plans/templates/$(basename "$template_file")"
done
```

Report what was linked vs skipped:
```
  Team: [TEAM_DISPLAY_NAME] ($TEAM_ID)
  Agents:
    → coordinator.md (linked from teams/$TEAM_ID/)
    → backend-architect.md (linked)
    → ui-ux-designer.md (linked)
    ~ frontend-architect.md (already exists, skipped)
    ...
  Plan templates:
    → feature-plan.md (linked)
    → bugfix-plan.md (linked)
    ...
```

### Step 5: Copy + Customize Per-Project Files

These files need per-project customization — copy them (skip existing):

#### Rules (copy then auto-populate)
```bash
mkdir -p .claude/rules
for rule in architecture api-conventions security-policy code-standards testing-standards env; do
  if [ ! -f ".claude/rules/$rule.md" ]; then
    cp "$TEMPLATE_DIR/.claude/rules/$rule.md" .claude/rules/
  fi
done
```

**After copying, auto-populate rules from codebase analysis.** Read the project's package.json, CLAUDE.md, README, and source files to fill in:
- **architecture.md** — project structure, tech stack, data flow, key patterns
- **api-conventions.md** — REST/GraphQL/tRPC conventions based on existing endpoints
- **code-standards.md** — language standards, linting config, import conventions
- **testing-standards.md** — test framework, naming patterns, coverage expectations
- **env.md** — environment variables from .env.example or process.env references
- **security-policy.md** — auth approach, OWASP considerations

Write realistic, useful content — not just variable names. These files should be immediately useful.

#### CLAUDE.md
```bash
if [ ! -f CLAUDE.md ]; then
  cp "$TEMPLATE_DIR/CLAUDE.md" CLAUDE.md
fi
```

#### Settings (merge, don't overwrite)
```bash
if [ ! -f .claude/settings.json ]; then
  cp "$TEMPLATE_DIR/.claude/settings.json" .claude/settings.json
fi
```

#### Marketplace
```bash
[ ! -f marketplace.json ] && cp "$TEMPLATE_DIR/marketplace.json" marketplace.json
```

### Step 6: Install Hooks

Merge hooks into existing `.claude/settings.json`. **Read the existing file first**, then merge — do not overwrite.

For each hook file in `$TEMPLATE_DIR/modules/hooks/` (security-scan, auto-format, type-check, audit-log):
1. Read the hook's JSON content
2. Check if a hook with the same `matcher` already exists in the settings
3. If not, append it to the appropriate array (PreToolUse or PostToolUse)
4. Write the updated settings.json back

### Step 7: Install MCP Servers

If `.mcp.json` doesn't exist, create it. Auto-detect which MCP servers are relevant based on the codebase:
- **github** — always include
- **filesystem** — always include
- **postgres/sqlite** — include if the project uses a database (check dependencies)
- **slack** — skip unless the project has slack-related code

```bash
if [ ! -f .mcp.json ]; then
  cp "$TEMPLATE_DIR/.mcp.json" .mcp.json
fi
```

Merge relevant server configs from `$TEMPLATE_DIR/modules/mcp/` into the mcpServers object.

### Step 8: Append CLAUDE.md Snippets

For each snippet in `$TEMPLATE_DIR/modules/claude-md-snippets/`:
1. Check if a similar section already exists in CLAUDE.md (search for the header)
2. If not, append the snippet content at the end of CLAUDE.md

### Step 9: Replace Placeholders

Replace all collected values in copied files:

```bash
PROJECT_SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

TARGET_FILES=$(find . \( -name "CLAUDE.md" -o -path "./.claude/rules/*" -o -name "marketplace.json" -o -name ".mcp.json" \) -type f)

for file in $TARGET_FILES; do
  sed -i "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" "$file"
  sed -i "s/\[YOUR_PROJECT\]/$PROJECT_SLUG/g" "$file"
  sed -i "s|\[e\.g\., SaaS web application / REST API / internal tool\]|$PROJECT_TYPE|g" "$file"
  sed -i "s|\[e\.g\., Next\.js 14 + TypeScript + PostgreSQL + Tailwind\]|$STACK|g" "$file"
  sed -i "s|\[1-2 sentences describing what this project does and who it's for\.\]|$DESCRIPTION|g" "$file"
  sed -i "s|\[Team name or size\]|$TEAM|g" "$file"
  sed -i "s|\[install command\]|$CMD_INSTALL|g" "$file"
  sed -i "s|\[dev command\]|$CMD_DEV|g" "$file"
  sed -i "s|\[test command\]|$CMD_TEST|g" "$file"
  sed -i "s|\[build command\]|$CMD_BUILD|g" "$file"
  sed -i "s|\[lint command\]|$CMD_LINT|g" "$file"
  sed -i "s/\[project-slug\]/$PROJECT_SLUG/g" "$file"
done
```

**Replace team placeholders** — generate team-specific content from `teams.json`:

For `[TEAM_NAME]`: Replace with `$TEAM_DISPLAY_NAME` (e.g., "SaaS Product").

For `[TEAM_TABLE]`: Generate a markdown table from the team's agent list:
```markdown
| Agent | When to Use |
|---|---|
| `coordinator` | Complex multi-layer tasks, parallel work coordination |
| `ui-ux-designer` | Visual design, design system, brand identity |
...
```
Each agent's "When to Use" description comes from the agent's `description` field in its frontmatter.

For `[TEAM_WORKFLOWS]`: Generate team-specific workflow recommendations based on the team's coordinator. Read the coordinator's Workflow section and produce a condensed version:
```markdown
**New feature:**
\`\`\`
coordinator → ui-ux-designer (design) → backend + frontend (parallel) → test-engineer → code-reviewer
\`\`\`
```

Replace in CLAUDE.md and any snippet files that were appended.

Remove the placeholder notice from CLAUDE.md:
```bash
sed -i '/Replace all.*PLACEHOLDER.*values/d' CLAUDE.md
```

### Step 10: Generate Project Plans

Analyze the existing codebase to understand what's built, then create stages for what comes next.

**Skip this step if `plans/active/` already contains stage files.**

#### 10a: Analyze the codebase

```bash
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) | head -50
cat package.json 2>/dev/null
find . -type f \( -name "*.test.*" -o -name "*.spec.*" \) | head -20
git log --oneline -20 2>/dev/null
```

Use Grep and Glob tools to understand the tech stack, existing features, patterns, and conventions.

#### 10b: Generate stage breakdown

Based on codebase analysis, determine what stages the project needs. For new projects, generate a full plan. For existing projects, generate stages for what comes next.

Ask the user ONE question:
```
Based on your codebase, I can generate plans for:
  (a) [inferred direction based on code analysis]
  (b) [alternative direction]
  (c) Something else — describe briefly

Which direction? (a/b/c)
```

#### 10c: Write stage plan files

Write each stage plan file directly to `plans/active/`. Each must include:
1. YAML frontmatter (title, type: stage, status: pending, created date, dependencies)
2. Agent directive: `> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.`
3. **Goal**, **Architecture**, **Tech Stack**, **Dependencies**
4. Task breakdown

For task breakdowns:
- **First 3 stages:** FULL detail — specific files, failing tests, implementation steps, commit messages, verification
- **Remaining stages:** Goal, Architecture, Dependencies, and task titles with brief descriptions

Conventions:
- Sequential dependencies — each stage builds on prior stages
- Test-driven — every task starts with failing tests
- Atomic commits — each task ends with a specific commit
- Deliverable verification — each stage ends with verification commands
- Realistic file paths — use actual paths from the codebase

### Step 11: Display Summary

```
================================================================
[TEAM_DISPLAY_NAME] Claude Code configuration installed!
================================================================

Team: [TEAM_DISPLAY_NAME] ($TEAM_ID)

Linked (shared — update once, all projects get it):
  .claude/agents/      — [N] specialist agents (team: $TEAM_ID)
  plans/templates/     — Feature, bugfix, stage, and context-handoff templates

Copied (project-specific):
  .claude/rules/       — Project knowledge base (auto-populated)
  .claude/settings.json — Hooks + permission rules
  plans/active/        — Stage plans (if generated)
  CLAUDE.md            — Project instructions
  .mcp.json            — MCP server configuration
  marketplace.json     — Plugin marketplace catalog

Skipped (already existed):
  [list of what was skipped]

================================================================
AGENT TEAM: [TEAM_DISPLAY_NAME]
================================================================

  coordinator          — orchestrates the team (Opus)
  [for each agent in TEAM_AGENTS, list name and brief description]

================================================================
NEXT STEPS:
================================================================

1. Review .claude/rules/ — auto-populated from your project details.
   Refine if needed: architecture.md, env.md, security-policy.md

2. Execute your first stage plan (if generated):
   - Open plans/active/stage-01-*.md
   - Paste into a new Claude Code session
   - Claude follows it task-by-task (TDD, commits, verification)

3. Restart Claude Code to activate agents, rules, and hooks

4. Try /team-battle to compare different team compositions

================================================================
```

### Step 12: Git Commit

```bash
git add .claude/ plans/ marketplace.json .mcp.json CLAUDE.md
git commit -m "chore: add $TEAM_DISPLAY_NAME Claude Code configuration

- [N] specialist agents: $TEAM_ID team (linked from shared source)
- .claude/rules/ knowledge base (auto-populated)
- Hooks: secret scan, auto-format, TypeScript check
- plans/ structure with templates (linked from shared source)
- marketplace.json, .mcp.json, CLAUDE.md"
```

---

## Error Handling

If shared files cannot be found:
```
ERROR: Enterprise shared files not found.

Install them first by running install-skills.sh from the claude-code-utils repo:

  cd claude-code-utils
  ./scripts/install-skills.sh enterprise

Or clone the repo:
  git clone https://github.com/[owner]/claude-code-utils
  cd claude-code-utils && ./scripts/install-skills.sh
```

If linking fails (falls back to copy):
```
NOTE: Could not create hardlinks (different drive or unsupported filesystem).
      Falling back to file copy. Files won't auto-update from shared source.
      To enable linking, ensure project and ~/.claude/ are on the same drive.
```
