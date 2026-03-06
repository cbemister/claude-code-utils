# Enterprise Enhancement Pack

Add enterprise-grade Claude Code capabilities to an existing project. Pick only the modules you need.

## Quick Start

Use the `/enterprise-enhance` skill to install modules interactively:

```
/enterprise-enhance
```

Or install manually by copying the module folders below.

---

## Available Modules

### `agent-teams/`
Eight specialized enterprise agents that coordinate as a team.

**What you get:**
- `coordinator` (Opus) — orchestrates complex multi-layer tasks
- `backend-architect` — API, database, service layer
- `frontend-architect` — UI components, state, accessibility
- `security-auditor` — OWASP, auth/authz, secrets review
- `test-engineer` — test strategy, coverage, automation
- `devops-engineer` — CI/CD, containers, infrastructure
- `code-reviewer` — quality, standards, pre-merge review
- `performance-analyst` — query optimization, bundle analysis

**Install:** Copy all `.md` files to `.claude/agents/`

---

### `rules/`
A template knowledge base for your project. Claude reads these automatically.

**What you get:**
- `architecture.md` — system design and layer boundaries
- `api-conventions.md` — endpoint patterns, request/response shapes
- `security-policy.md` — auth requirements, validation rules, secrets policy
- `code-standards.md` — naming conventions, patterns to follow and avoid
- `testing-standards.md` — coverage targets, test framework conventions
- `env.md` — all environment variables

**Install:** Copy all `.md` files to `.claude/rules/` — then customize each file for your project.

> Rules only work if they reflect reality. Customize before using.

---

### `context-management/`
Tools for managing context across long-running work and multiple Claude Code sessions.

**What you get:**
- `plans/feature-plan.md` — feature development plan template
- `plans/bugfix-plan.md` — bug investigation plan template
- `plans/context-handoff.md` — cross-thread context transfer template
- `memory-setup.md` — guide for configuring session memory

**Install:** Copy `plans/` templates to your `plans/templates/` directory. Read `memory-setup.md` to configure session journaling.

**Works with:** `/create-plan`, `/plan-status`, `/summarize-session` skills (install from `~/.claude/skills/`)

---

### `marketplace/`
Publish your project's agents and skills as a Claude Code plugin marketplace.

**What you get:**
- `marketplace.json` — template plugin catalog
- `README.md` — publishing guide

**Install:** Copy `marketplace.json` to your project root, customize with your agents/skills, then follow the publishing guide.

**Validate:** `claude plugin validate .`

---

### `hooks/`
Pre-configured safety and automation hooks for `.claude/settings.json`.

**What you get:**
- `security-scan.json` — blocks dangerous shell patterns, scans for hardcoded secrets
- `auto-format.json` — runs Prettier/Black on save
- `type-check.json` — runs TypeScript type checking on `.ts`/`.tsx` edits
- `audit-log.json` — appends tool usage to `.claude/audit.log`

**Install:** Merge the JSON content from each hook file into the `hooks` section of your `.claude/settings.json`. See each file's README for merging instructions.

---

### `mcp/`
MCP server configuration stubs for common enterprise integrations.

**What you get:**
- `github.json` — GitHub API access via MCP
- `postgres.json` — PostgreSQL database queries via MCP
- `slack.json` — Slack messaging via MCP
- `filesystem.json` — File system access via MCP

**Install:** Merge the chosen server configs into your `.mcp.json`. Set the required environment variables from `.claude/rules/env.md`.

---

### `claude-md-snippets/`
Markdown sections ready to paste into an existing CLAUDE.md.

**What you get:**
- `enterprise-standards.md` — code quality, review, and deployment standards section
- `agent-team-guide.md` — when and how to invoke each enterprise agent
- `rules-guide.md` — how the `.claude/rules/` system works
- `context-management.md` — session workflow: plans + `/summarize-session`

**Install:** Open your CLAUDE.md, identify where each snippet fits, and paste the content. Each snippet is self-contained and includes a suggested placement comment.

---

## Recommended Installation Order

For a fresh enhancement, install in this order:

1. **rules/** — Establish the knowledge base first (agents need it)
2. **agent-teams/** — Install agents that reference the rules
3. **hooks/** — Add safety and automation
4. **context-management/** — Set up planning and session workflow
5. **claude-md-snippets/** — Update CLAUDE.md with new sections
6. **marketplace/** — Publish when ready
7. **mcp/** — Add integrations as needed

---

## After Installation

1. Customize all `[PLACEHOLDER]` values in rules files
2. Run `claude plugin validate .` if you installed the marketplace module
3. Restart Claude Code to pick up new agents, rules, and hooks
4. Run `/plan-status` to verify plan tooling works