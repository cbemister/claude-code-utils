# Agent Teams

## Team System

The project provides a **pool of 11 agents** that are composed into **5 team presets**. All teams are build-focused — design agents are available as standalone skills but not included in team builds.

### Agent Pool

| Agent | Model | Category |
|---|---|---|
| `coordinator` | Opus | Orchestration |
| `ui-ux-designer` | Opus | Design — available via design skills, not in teams |
| `mobile-designer` | Opus | Design — available via design skills, not in teams |
| `conversion-optimizer` | Opus | Design — available via design skills, not in teams |
| `backend-architect` | Sonnet | Architecture |
| `frontend-architect` | Sonnet | Architecture |
| `security-auditor` | Sonnet | Specialist |
| `test-engineer` | Sonnet | Specialist |
| `devops-engineer` | Sonnet | Specialist |
| `code-reviewer` | Sonnet | Specialist |
| `performance-analyst` | Sonnet | Specialist |

### Team Presets (`templates/enhance-app/teams/teams.json`)

| Team | Engineering Agents | Use Case |
|---|---|---|
| Enterprise Engineering | All 7 | APIs, data pipelines, complex backends |
| SaaS Product | 6 (no devops) | SaaS products on managed platforms |
| Internal Tool | All 7 | Admin panels, developer tools |
| Game / Interactive | 4 (backend, frontend, test, perf) | Games, creative tools |
| Marketing Site | 3 (frontend, perf, review) | Landing pages, marketing |

### Design After Build

Design agents are not included in team builds. Apply design as a separate pass using skills:
- `/style <theme>` — Apply themed aesthetic
- `/color-palette` — Refine colors
- `/typography-system` — Font hierarchy
- `/enhance-design` — Full design pass (chains all design skills)

### Team Battle (`/team-battle`)

Compares two teams on the same task by creating isolated worktrees, running the task in each, and presenting side-by-side results.

## File Locations

- Agent definitions: `templates/enhance-app/.claude/agents/`
- Team config: `templates/enhance-app/teams/teams.json`
- Team coordinators: `templates/enhance-app/teams/<team>/coordinator.md`
- Team docs: `templates/enhance-app/teams/README.md`
- CLAUDE.md snippet: `templates/enhance-app/modules/claude-md-snippets/agent-team-guide.md`

## Adding Agents

1. Create markdown file in `templates/enhance-app/.claude/agents/<name>.md`
2. Add YAML frontmatter: name, description, tools, model, skills
3. Add agent to relevant team(s) in `teams/teams.json`
4. Create/update coordinator for affected teams
5. Update `templates/enhance-app/.claude/agents/README.md`
