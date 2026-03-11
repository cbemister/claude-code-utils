# Architecture

## Overview

This is a **resource library**, not an application. It contains shareable Claude Code resources — sub-agents, skills, commands, templates, and documentation — that can be installed into other projects or used globally.

## Directory Structure

```
claude-code-utils/
├── .claude/
│   ├── agents/           # Base agent library (explore, plan, implement)
│   │   ├── design/       # Design agents (ui-ux-designer)
│   │   ├── explore/      # Exploration agents (haiku)
│   │   └── implement/    # Implementation agents (sonnet)
│   └── skills/           # 40+ project-local skills
│       └── <name>/SKILL.md
├── templates/
│   ├── claude-md/        # CLAUDE.md templates per tech stack
│   └── enhance-app/      # Enterprise project setup template
│       ├── .claude/agents/   # 11-agent team pool
│       ├── teams/            # 5 team presets + team battle
│       ├── modules/          # CLAUDE.md snippets
│       └── plans/templates/  # Plan templates
├── plans/templates/      # Plan templates (feature, bugfix, refactor, stage)
├── docs/                 # Documentation and best practices
├── scripts/              # Installation scripts
└── CLAUDE.md             # Project instructions
```

## Key Concepts

### Resource Types

1. **Sub-agents** — Markdown files with YAML frontmatter, dispatched by Claude for specialized tasks
2. **Skills** — Workflow automations invoked with `/skill-name`, each in a `<name>/SKILL.md` directory
3. **Agent teams** — Curated groups of agents optimized for project types (defined in `teams/teams.json`)
4. **Plan templates** — Structured planning documents for features, bugs, refactors, and staged builds
5. **Rules** — Project knowledge files auto-loaded by Claude (`.claude/rules/*.md`)

### Two-Level Agent System

- **Base library** (`.claude/agents/`) — Generic agents usable in any project (explore, plan, implement categories)
- **Team pool** (`templates/enhance-app/.claude/agents/`) — 11 specialized agents selected by team presets

### Template vs. Installed

- `templates/enhance-app/` is a **template** — it contains placeholder values (`[PROJECT_NAME]`, `[TEAM_NAME]`)
- When `/enhance-app` runs, it copies and customizes these into the target project
- Skills in `.claude/skills/` work immediately when project-local — no install needed

## Conventions

- All markdown content — no compiled code in this repo
- YAML frontmatter for metadata on agents and skills
- Conventional commits: `feat`, `fix`, `docs`, `refactor`
- Windows Git Bash compatible (forward slashes in paths)
