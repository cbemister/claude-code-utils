# Enterprise Agent Team

Eight specialized agents for enterprise-grade development. Each agent focuses on a specific domain and works within the project's established rules and conventions.

## Team Structure

### Coordinator (Opus)
- **`coordinator`** — Orchestrates multi-agent tasks, decomposes complex features, resolves conflicts

### Architects (Sonnet)
- **`backend-architect`** — API design, database schema, service layer, data validation
- **`frontend-architect`** — UI components, state management, routing, accessibility

### Specialists (Sonnet)
- **`security-auditor`** — OWASP, auth/authz, secrets, input validation
- **`test-engineer`** — Unit, integration, and E2E tests; coverage strategy
- **`devops-engineer`** — CI/CD, containers, infrastructure, monitoring
- **`code-reviewer`** — Quality, standards, correctness, maintainability
- **`performance-analyst`** — Query optimization, bundle analysis, caching

## When to Use Each Agent

| Task | Agent |
|---|---|
| Complex feature spanning multiple layers | `coordinator` |
| New API endpoint or database change | `backend-architect` |
| New page, component, or UI flow | `frontend-architect` |
| Any auth/permission change | `security-auditor` |
| Adding test coverage | `test-engineer` |
| CI/CD or deployment change | `devops-engineer` |
| Pre-merge review | `code-reviewer` |
| Slow queries or page load times | `performance-analyst` |

## Recommended Workflows

### Feature Development
```
coordinator → backend-architect + frontend-architect (parallel)
           → security-auditor (auth review if needed)
           → test-engineer
           → code-reviewer
```

### Bug Investigation
```
performance-analyst or code-reviewer → backend-architect or frontend-architect → test-engineer
```

### Pre-Launch Review
```
security-auditor + performance-analyst (parallel) → code-reviewer
```

## Agent + Rules Integration

All agents reference `.claude/rules/` files automatically. Keep rules updated as the project evolves — agents perform better with accurate, current documentation.

## Customizing This Team

Add agents for your specific domain needs:
- `data-engineer` — ETL pipelines, analytics, data warehouse
- `ml-engineer` — Model integration, inference optimization, data pipelines
- `mobile-architect` — React Native, mobile-specific patterns
- `accessibility-specialist` — Deep WCAG review beyond basics

Follow the agent format in `templates/agents/agent-template.md`.
