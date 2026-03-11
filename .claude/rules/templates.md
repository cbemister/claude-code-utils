# Templates

## Overview

Templates are starter configurations that get copied and customized into target projects. They are **not used directly** — they contain placeholder values that are replaced during installation.

## Template Types

### CLAUDE.md Templates (`templates/claude-md/`)

Ready-to-use CLAUDE.md files for different tech stacks:
- `minimal.md` — Simple projects
- `nextjs-app.md` — Next.js applications
- `node-library.md` — npm packages
- `api-service.md` — REST APIs
- `cli-tool.md` — CLI applications
- `python-app.md` — Python projects
- `game-browser.md` — Browser games

### Prep-Claude Template (`templates/prep-claude/`)

Full enterprise project setup. Installed via `/prep-claude` skill.

Contains:
- `.claude/agents/` — 11 agent definitions (the team pool)
- `.claude/rules/` — 6 customizable rule files (architecture, API, security, code standards, testing, env)
- `teams/` — 5 team presets with coordinators and `teams.json`
- `modules/claude-md-snippets/` — Snippets for composing CLAUDE.md files
- `plans/templates/` — Plan templates
- `CLAUDE.md` — Template with placeholders (`[PROJECT_NAME]`, `[TEAM_NAME]`, etc.)

### Plan Templates (`plans/templates/`)

| Template | Purpose |
|---|---|
| `feature-plan.md` | New feature with 4 phases (research, design, implement, test) |
| `bugfix-plan.md` | Bug investigation and fix with 3 phases |
| `refactor-plan.md` | Code refactoring with 4 phases |
| `stage-plan.md` | Build stage with agent teams, task parallelization, tiered verification |
| `subplan-template.md` | Phase sub-plan within a larger plan |

### Stage Plan Template (`plans/templates/stage-plan.md`)

Designed for multi-stage app builds. Key features:
- **Agent team assignments** — Lead/Support/Review roles per stage
- **Parallelization diagrams** — ASCII graphs showing concurrent vs sequential tasks
- **Tiered verification** — Tier 1 (compiles), Tier 2 (unit), Tier 3 (E2E) per task
- **Code specifications** — TypeScript interfaces inline to reduce ambiguity
- **Files manifest** — Each task lists files with new/modify/extend annotations
- **Stage checkpoint** — Quantified success criteria table with gate condition

## Placeholder Conventions

- `[PROJECT_NAME]` — Project name
- `[TEAM_NAME]` — Agent team preset name
- `[TEAM_TABLE]` — Agent roster table (filled by prep-claude)
- `[TEAM_WORKFLOWS]` — Workflow diagrams (filled by prep-claude)
- `YYYY-MM-DD` — Current date
- `[CUSTOMIZE THIS FILE]` — Rule files that need project-specific content
