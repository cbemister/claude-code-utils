---
name: enterprise-starter
description: Scaffold the enterprise starter template into the current project directory. Creates the full .claude/ config layer including 8 specialized agents, rules knowledge base, hooks, plans structure, marketplace.json, MCP server stubs, and an enterprise CLAUDE.md. Use when starting a new project that needs enterprise-grade Claude Code configuration.
---

# Enterprise Starter Skill

Scaffold the enterprise Claude Code configuration layer into the current directory.

## Instructions

**IMPORTANT: Non-interactive where possible. Complete all steps without pausing unless a decision is required.**

### Step 1: Pre-flight Check & Auto-detect

1. Check if `.claude/` already exists — if so, warn and continue (existing files won't be overwritten)
2. If not a git repo, initialize one automatically: `git init`

### Step 2: Gather Project Details (auto-detect first, then ask)

**Auto-detect as much as possible** before asking the user anything:

```bash
# Project name from directory
PROJECT_NAME=$(basename "$PWD")

# Read package.json, Cargo.toml, go.mod, pyproject.toml, etc.
cat package.json 2>/dev/null
cat README.md 2>/dev/null | head -30
cat Cargo.toml 2>/dev/null
cat go.mod 2>/dev/null
cat pyproject.toml 2>/dev/null
```

From these files, infer:
- **PROJECT_NAME** — from directory name or package.json `name`
- **STACK** — from dependencies (e.g., if package.json has `next` → "Next.js + TypeScript", if it has `express` → "Express + TypeScript")
- **PROJECT_TYPE** — from STACK + README context (web app, API, CLI, library)
- **DESCRIPTION** — from package.json `description` or first line of README
- **CMD_INSTALL / CMD_DEV / CMD_TEST / CMD_BUILD / CMD_LINT** — from package.json `scripts` (map `dev`, `test`, `build`, `lint` to their commands, default to npm/bun/pnpm based on lockfile)

Detect the package manager:
```bash
[ -f bun.lockb ] && PM="bun" || { [ -f pnpm-lock.yaml ] && PM="pnpm" || { [ -f yarn.lock ] && PM="yarn" || PM="npm"; }; }
```

Use `$PM run dev`, `$PM run test`, etc. as defaults.

**Then present a single confirmation** with everything pre-filled:

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

Only ask for values that genuinely could not be detected (e.g., TEAM, or PROJECT_TYPE for an empty project). For anything with a reasonable default, use it without asking.

Store as variables:
- PROJECT_NAME, PROJECT_TYPE, STACK, DESCRIPTION, TEAM
- CMD_INSTALL, CMD_DEV, CMD_TEST, CMD_BUILD, CMD_LINT

### Step 3: Find Template Source

Locate the enterprise-starter template. Check these locations in order:
1. `~/.claude/skills/enterprise-starter/templates/enterprise-starter/` (if installed globally)
2. The claude-code-utils repository: Look for `templates/enterprise-starter/` relative to the skill location

Store the source path as `TEMPLATE_DIR`.

If the template cannot be found, print an error with instructions to install from the claude-code-utils repository.

### Step 4: Copy Template Files

Copy the following from `TEMPLATE_DIR` to the current directory, skipping files that already exist:

```bash
# Create directory structure
mkdir -p .claude/agents .claude/rules plans/active plans/archive plans/templates

# Copy agents
cp -n "$TEMPLATE_DIR/.claude/agents/"*.md .claude/agents/ 2>/dev/null || true
cp -n "$TEMPLATE_DIR/.claude/agents/README.md" .claude/agents/README.md 2>/dev/null || true

# Copy rules
cp -n "$TEMPLATE_DIR/.claude/rules/"*.md .claude/rules/ 2>/dev/null || true

# Copy settings.json (only if it doesn't exist)
if [ ! -f .claude/settings.json ]; then
  cp "$TEMPLATE_DIR/.claude/settings.json" .claude/settings.json
fi

# Copy plan templates
cp -n "$TEMPLATE_DIR/plans/templates/"*.md plans/templates/ 2>/dev/null || true

# Copy root config files (only if they don't exist)
[ ! -f marketplace.json ] && cp "$TEMPLATE_DIR/marketplace.json" marketplace.json
[ ! -f .mcp.json ] && cp "$TEMPLATE_DIR/.mcp.json" .mcp.json

# Copy CLAUDE.md (only if one doesn't exist)
if [ ! -f CLAUDE.md ]; then
  cp "$TEMPLATE_DIR/CLAUDE.md" CLAUDE.md
fi
```

### Step 5: Replace Placeholders

Replace all collected values in copied files. Use the variables from Step 2.

Also derive `PROJECT_SLUG` (lowercase, hyphens) from PROJECT_NAME for use in paths.

```bash
# Derive slug from project name (lowercase, spaces→hyphens)
PROJECT_SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

TARGET_FILES=$(find . \( -name "CLAUDE.md" -o -path "./.claude/*" -o -path "./plans/*" -o -name "marketplace.json" -o -name ".mcp.json" \) -type f)

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

Remove the `> Replace all [PLACEHOLDER] values...` notice from CLAUDE.md since placeholders are already filled:
```bash
sed -i '/Replace all.*PLACEHOLDER.*values/d' CLAUDE.md
```

#### 5b: Auto-populate rules files

Do NOT leave rules files with generic placeholders. Use the project details from Step 2 to fill them in automatically:

- **architecture.md** — Fill in the project type, stack, directory structure (based on STACK conventions — e.g., `src/app/` for Next.js, `packages/` for monorepos), data flow description, and key patterns
- **api-conventions.md** — Fill in REST/GraphQL/tRPC conventions based on STACK (e.g., Next.js API routes vs Express endpoints)
- **code-standards.md** — Fill in language-specific standards (TypeScript strict mode, ESLint config, import conventions based on the stack)
- **testing-standards.md** — Fill in the test framework (vitest/jest/pytest based on STACK), coverage expectations, and file naming patterns
- **env.md** — Fill in typical environment variables for the STACK (e.g., `DATABASE_URL` for Prisma, `NEXTAUTH_SECRET` for Next-Auth), mark which are required vs optional
- **security-policy.md** — Fill in auth approach based on STACK, OWASP considerations for the project type

Use your knowledge of the stack to write realistic, useful content — not just fill in variable names. These files should be immediately useful, not require manual editing.

### Step 6: Build a Project Plan for Agent Teams

**Automatically generate the full plan** using the project details already collected in Step 2 (PROJECT_TYPE, STACK, DESCRIPTION). Do not ask the user to describe milestones — infer them from the project type and stack.

#### 6a: Generate stage breakdown

Based on PROJECT_TYPE and STACK, automatically determine the right stages. Use your knowledge of the stack to produce a realistic, production-grade stage breakdown. Typical patterns:

**Web app (Next.js/React + DB):**
Stage 1: Foundation (project scaffold, DB schema, config, health check)
Stage 2: Auth (user model, sessions/JWT, login/register/logout)
Stage 3: Core data models (CRUD for primary entities, validation)
Stage 4: API layer (REST or tRPC endpoints, error handling, middleware)
Stage 5: Frontend shell (layout, nav, routing, auth guards)
Stage 6: Core UI (pages for primary entities, forms, data tables)
Stage 7: Integration (connect frontend to API, loading/error states)
Stage 8: Testing & hardening (E2E tests, input validation, rate limiting)
Stage 9: Polish & deploy (performance, SEO, CI/CD, production config)

**API service:**
Stage 1: Foundation (project scaffold, DB, config, health check)
Stage 2: Auth & middleware (API keys or JWT, rate limiting, CORS)
Stage 3-N: One stage per resource/domain (endpoints + tests)
Stage N+1: Integration testing & documentation
Stage N+2: Deploy & monitoring

**CLI tool / library:**
Stage 1: Foundation (project scaffold, config parsing, help output)
Stage 2-N: One stage per major command or feature
Stage N+1: Testing, docs, publish config

Adapt as needed — these are starting points, not rigid templates. The key is that each stage produces working, testable code.

#### 6b: Write stage plan files

For each stage, create a file directly (do not copy the template — write the full content):

```bash
# Write each stage plan directly to plans/active/
```

Each stage plan file must include:
1. YAML frontmatter (title, type: stage, status: pending, created date, dependencies)
2. The agent directive: `> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.`
3. **Goal** — 1-2 sentences
4. **Architecture** — how pieces fit together
5. **Tech Stack** — from STACK variable
6. **Dependencies** — which prior stages must be complete

For task breakdowns:
- **First 3 stages:** Write the FULL task breakdown — specific files to create/modify, failing tests to write, implementation steps with code snippets for key decisions, commit messages, and deliverable verification
- **Remaining stages:** Write Goal, Architecture, Dependencies, and task titles with brief descriptions. These get fleshed out when earlier stages complete.

#### 6c: Stage plan conventions (enforce these)

- **Sequential dependencies:** Each stage builds on prior stages
- **Test-driven:** Every task starts with failing tests, then implementation
- **Atomic commits:** Each task ends with a specific `git add` + `git commit -m "..."` command
- **Deliverable verification:** Each stage ends with bash commands to verify everything works
- **Agent directive at top:** Always include the executing-plans directive
- **Realistic file paths:** Use actual paths based on the STACK (e.g., `src/app/` for Next.js, `packages/` for monorepos)

#### 6d: Present the plan for confirmation

After generating all stage files, display a summary:

```
================================================================
PROJECT PLAN GENERATED
================================================================

  plans/active/stage-01-foundation.md        ★ full task breakdown
  plans/active/stage-02-auth.md              ★ full task breakdown
  plans/active/stage-03-core-models.md       ★ full task breakdown
  plans/active/stage-04-api-layer.md           outline (flesh out later)
  plans/active/stage-05-frontend-shell.md      outline (flesh out later)
  ...

★ = ready to execute immediately with superpowers:executing-plans

To execute a stage:
  1. Open the stage plan file
  2. Paste its contents into a new Claude Code session
  3. Claude follows the plan task-by-task (TDD, commits, verification)

To archive completed stages:
  mv plans/active/stage-01-*.md plans/archive/
================================================================
```

Do NOT ask for confirmation before writing the files — just generate them. The user can review and edit the files afterward. Speed over ceremony.

### Step 7: Display Results

Print a clear summary:

```
================================================================
Enterprise Claude Code configuration installed!
================================================================

Created:
  .claude/agents/      — 8 enterprise specialist agents
  .claude/rules/       — Project knowledge base (customize these!)
  .claude/settings.json — Hooks + permission rules
  plans/templates/     — Feature, bugfix, stage, and context-handoff templates
  plans/active/        — Active stage plans (if project plan was created)
  marketplace.json     — Plugin marketplace catalog
  .mcp.json            — MCP server stubs
  CLAUDE.md            — Enterprise project instructions

================================================================
READY TO GO:
================================================================

1. Review .claude/rules/ — auto-populated from your project details.
   Refine if needed: architecture.md, env.md, security-policy.md

2. Execute your first stage plan:
   - Open plans/active/stage-01-*.md
   - Paste into a new Claude Code session
   - Claude follows it task-by-task (TDD, commits, verification)

3. Restart Claude Code to activate agents, rules, and hooks

================================================================
AGENT TEAM READY:
================================================================

  coordinator          — orchestrates complex multi-layer tasks (Opus)
  backend-architect    — API, database, service layer (Sonnet)
  frontend-architect   — UI components, state, accessibility (Sonnet)
  security-auditor     — OWASP, auth/authz, secrets review (Sonnet)
  test-engineer        — test strategy, coverage, automation (Sonnet)
  devops-engineer      — CI/CD, containers, infrastructure (Sonnet)
  code-reviewer        — quality, standards, pre-merge review (Sonnet)
  performance-analyst  — query optimization, bundle analysis (Sonnet)

================================================================
```

### Step 8: Validate marketplace.json

```bash
claude plugin validate . 2>&1 || echo "Note: Run 'claude plugin validate .' to validate marketplace.json after customizing"
```

### Step 9: Git Commit

Automatically commit the enterprise configuration:

```bash
git add .claude/ plans/ marketplace.json .mcp.json CLAUDE.md
git commit -m "chore: add enterprise Claude Code configuration

- 8 specialized agents (coordinator, backend-architect, frontend-architect,
  security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst)
- .claude/rules/ knowledge base (customize for your project)
- Hooks: secret scan, auto-format, TypeScript check, bash protection
- plans/ structure with feature, bugfix, and context-handoff templates
- marketplace.json for plugin distribution
- .mcp.json MCP server configuration stubs"
```

---

## Error Handling

If template files cannot be found:
```
ERROR: Enterprise starter templates not found.

Install the claude-code-utils repository and run from there, or install
the enterprise-starter skill globally:

  git clone https://github.com/[owner]/claude-code-utils
  cd your-project
  /enterprise-starter
```

If files already exist and user declines to continue:
```
Aborted. Use /enterprise-enhance to selectively add enterprise features
to a project that already has Claude Code configuration.
```
