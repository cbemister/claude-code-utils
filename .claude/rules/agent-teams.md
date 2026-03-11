# Agent Teams

## Team System

The project provides a **pool of 11 agents** that are composed into **5 team presets**. Each preset is optimized for a different project type.

### Agent Pool

| Agent | Model | Category |
|---|---|---|
| `coordinator` | Opus | Orchestration |
| `ui-ux-designer` | Opus | Design — 14 skills (color, typography, spacing, components, etc.) |
| `mobile-designer` | Opus | Design — 5 skills (mobile patterns, touch, accessibility) |
| `conversion-optimizer` | Opus | Design — 5 skills (conversion, copywriting, CTAs, social proof) |
| `backend-architect` | Sonnet | Architecture |
| `frontend-architect` | Sonnet | Architecture |
| `security-auditor` | Sonnet | Specialist |
| `test-engineer` | Sonnet | Specialist |
| `devops-engineer` | Sonnet | Specialist |
| `code-reviewer` | Sonnet | Specialist |
| `performance-analyst` | Sonnet | Specialist |

### Team Presets (`templates/prep-claude/teams/teams.json`)

| Team | Design Agents | Engineering Agents | Use Case |
|---|---|---|---|
| Enterprise Engineering | None | All 7 | APIs, data pipelines, complex backends |
| SaaS Product | UI/UX + Conversion | 6 (no devops) | Revenue-driven SaaS products |
| Internal Tool | UI/UX (practical) | All 7 | Admin panels, developer tools |
| Game / Interactive | UI/UX + Mobile | 4 (backend, frontend, test, perf) | Games, creative tools |
| Marketing Site | All 3 designers | 3 (frontend, perf, review) | Landing pages, marketing |

### Team Battle (`/team-battle`)

Compares two teams on the same task by creating isolated worktrees, running the task in each, and presenting side-by-side results.

## File Locations

- Agent definitions: `templates/prep-claude/.claude/agents/`
- Team config: `templates/prep-claude/teams/teams.json`
- Team coordinators: `templates/prep-claude/teams/<team>/coordinator.md`
- Team docs: `templates/prep-claude/teams/README.md`
- CLAUDE.md snippet: `templates/prep-claude/modules/claude-md-snippets/agent-team-guide.md`

## Adding Agents

1. Create markdown file in `templates/prep-claude/.claude/agents/<name>.md`
2. Add YAML frontmatter: name, description, tools, model, skills
3. Add agent to relevant team(s) in `teams/teams.json`
4. Create/update coordinator for affected teams
5. Update `templates/prep-claude/.claude/agents/README.md`
