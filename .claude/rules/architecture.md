# Architecture

## Overview

This is a **resource library**, not an application. It contains shareable Claude Code resources — sub-agents, skills, commands, templates, and documentation — that can be installed into other projects or used globally.

## Directory Structure

```
claude-code-utils/
├── .claude/
│   ├── agents/           # Base agent library (7 agents)
│   │   ├── design/       # designer (Opus, skill-driven)
│   │   ├── explore/      # explorer (Haiku, read-only)
│   │   ├── plan/         # planner, project-planner (Opus, read-only)
│   │   └── implement/    # feature-builder, test-writer, debugger (Sonnet)
│   └── skills/           # 29 project-local skills
│       └── <name>/SKILL.md
├── templates/
│   ├── claude-md/        # CLAUDE.md templates per tech stack
│   └── enhance-app/      # Enterprise project setup template
│       ├── .claude/agents/   # 8-agent team pool (no design agents)
│       ├── teams/            # 5 team presets + team battle
│       └── modules/          # CLAUDE.md snippets
├── plans/templates/      # Plan templates (feature, bugfix, refactor, stage, optimization, context-handoff, master-plan)
├── docs/                 # Documentation and best practices
├── scripts/              # Installation scripts
│   └── install-resources.sh
└── CLAUDE.md             # Project instructions
```

## Key Concepts

### Resource Types

1. **Sub-agents** — Markdown files with YAML frontmatter, dispatched by Claude for specialized tasks
2. **Skills** — Workflow automations invoked with `/skill-name`, each in a `<name>/SKILL.md` directory
3. **Agent teams** — Curated groups of agents optimized for project types (defined in `teams/teams.json`)
4. **Plan templates** — Structured planning documents for features, bugs, refactors, and staged builds
5. **Rules** — Project knowledge files auto-loaded by Claude (`.claude/rules/*.md`)
6. **Evolution state** — JSON/markdown files tracking product evaluation scores, optimization hypotheses, and evolution cycles (`factory/` directory in target projects)

### CodeForge Bot (Separate Repo)

The Slack bot (CodeForge Bot) has been split into its own repository at `C:\Users\chris\Code-Projects\CodeForge`. It provides a conversational Slack interface to the software factory. The bot invokes Claude CLI with factory skills — no code-level dependency on this repo.

### Two-Level Agent System

- **Base library** (`.claude/agents/`) — 7 generic agents: `explorer`, `planner`, `project-planner`, `designer`, `feature-builder`, `test-writer`, `debugger`
- **Team pool** (`templates/enhance-app/.claude/agents/`) — 8 specialized build agents (coordinator + 7 engineering specialists); design is applied via skills

### Template vs. Installed

- `templates/enhance-app/` is a **template** — it contains placeholder values (`[PROJECT_NAME]`, `[TEAM_NAME]`)
- When `/enhance-app` runs, it copies and customizes these into the target project
- Skills in `.claude/skills/` work immediately when project-local — no install needed

## Conventions

- All markdown content — no compiled code in this repo
- YAML frontmatter for metadata on agents and skills
- Conventional commits: `feat`, `fix`, `docs`, `refactor`
- Windows Git Bash compatible (forward slashes in paths)
