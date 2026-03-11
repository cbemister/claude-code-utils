# Agent Team Pool

Eleven specialized agents available for team-based selection. When you run `/enhance-app`, you choose a team preset — only the agents for that team are installed in your project.

## Available Agents

### Coordinator (Opus)
- **`coordinator`** — Orchestrates multi-agent tasks, decomposes complex features, resolves conflicts. Each team has its own coordinator variant with a tailored roster and workflow.

### Design Agents (Opus)
- **`ui-ux-designer`** — Visual design, design systems, brand-driven interfaces (14 design skills)
- **`mobile-designer`** — Mobile-first UX, thumb zone ergonomics, platform-aware patterns (5 skills)
- **`conversion-optimizer`** — Conversion psychology, copywriting, CTAs, social proof (5 skills)

### Architects (Sonnet)
- **`backend-architect`** — API design, database schema, service layer, data validation
- **`frontend-architect`** — UI components, state management, routing, accessibility

### Specialists (Sonnet)
- **`security-auditor`** — OWASP, auth/authz, secrets, input validation
- **`test-engineer`** — Unit, integration, and E2E tests; coverage strategy
- **`devops-engineer`** — CI/CD, containers, infrastructure, monitoring
- **`code-reviewer`** — Quality, standards, correctness, maintainability
- **`performance-analyst`** — Query optimization, bundle analysis, caching

## Team Presets

Teams are defined in `teams/teams.json`. Each team includes a subset of agents from this pool plus a custom coordinator.

| Team | Agents | Design | Best For |
|------|--------|--------|----------|
| Enterprise Engineering | 8 | None | Complex apps, internal tools |
| SaaS Product | 9 | UI/UX + Conversion | SaaS products, dashboards |
| Internal Tool | 9 | UI/UX (practical) | Admin panels, developer tools |
| Game / Interactive | 7 | UI/UX + Mobile | Games, creative tools |
| Marketing Site | 7 | All 3 designers | Landing pages, marketing |

See `teams/README.md` for detailed comparison and selection guide.

## Agent + Rules Integration

All agents reference `.claude/rules/` files automatically. Keep rules updated as the project evolves — agents perform better with accurate, current documentation.

## Adding Custom Agents

Add agents for your specific domain needs:
- `data-engineer` — ETL pipelines, analytics, data warehouse
- `ml-engineer` — Model integration, inference optimization, data pipelines
- `accessibility-specialist` — Deep WCAG review beyond basics

Agent format: Markdown files with YAML frontmatter (name, description, tools, model, skills).
