# Agent Team Pool

Eight specialized agents available for team-based selection. When you run `/enhance-app`, you choose a team preset — only the agents for that team are installed in your project.

## Available Agents

### Coordinator (Opus)
- **`coordinator`** — Orchestrates multi-agent tasks, decomposes complex features, resolves conflicts. Each team has its own coordinator variant with a tailored roster and workflow.

### Architects (Sonnet)
- **`backend-architect`** — API design, database schema, service layer, data validation
- **`frontend-architect`** — UI components, state management, routing, accessibility

### Specialists (Sonnet)
- **`security-auditor`** — OWASP, auth/authz, secrets, input validation
- **`test-engineer`** — Unit, integration, and E2E tests; coverage strategy
- **`devops-engineer`** — CI/CD, containers, infrastructure, monitoring
- **`code-reviewer`** — Quality, standards, correctness, maintainability
- **`performance-analyst`** — Query optimization, bundle analysis, caching

## Design After Build

Design agents are not in team builds — design work is applied as a separate pass using skills:
- `/style <theme>` — Apply a visual theme
- `/design-system` — Color, typography, spacing, layout
- `/enhance-design` — Full design pass (all phases)

## Team Presets

Teams are defined in `teams/teams.json`. Each team includes a subset of agents from this pool plus a custom coordinator.

| Team | Agents | Best For |
|------|--------|----------|
| Enterprise Engineering | coordinator + 7 | Complex apps, internal tools |
| SaaS Product | coordinator + 6 (no devops) | SaaS products, dashboards |
| Internal Tool | coordinator + 7 | Admin panels, developer tools |
| Game / Interactive | coordinator + 4 (backend, frontend, test, perf) | Games, creative tools |
| Marketing Site | coordinator + 3 (frontend, perf, review) | Landing pages, marketing |

See `teams/README.md` for detailed comparison and selection guide.

## Agent + Rules Integration

All agents reference `.claude/rules/` files automatically. Keep rules updated as the project evolves — agents perform better with accurate, current documentation.

## Adding Custom Agents

Add agents for your specific domain needs:
- `data-engineer` — ETL pipelines, analytics, data warehouse
- `ml-engineer` — Model integration, inference optimization, data pipelines
- `accessibility-specialist` — Deep WCAG review beyond basics

Agent format: Markdown files with YAML frontmatter (name, description, tools, model, skills).
