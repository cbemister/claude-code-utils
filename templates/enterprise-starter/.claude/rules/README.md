# Project Rules

Rules are project-specific markdown files that Claude reads automatically alongside CLAUDE.md. They serve as a living knowledge base about this project's architecture, conventions, and requirements.

## How Rules Work

Claude Code auto-loads all `.md` files in `.claude/rules/` when you open a project. Agents reference these files explicitly to understand context before making decisions. Unlike CLAUDE.md (which provides general instructions), rules files document **what exists** in this specific project.

## Files in This Directory

| File | Purpose |
|---|---|
| `architecture.md` | System design, layer boundaries, key architectural decisions |
| `api-conventions.md` | Endpoint naming, request/response shapes, error formats |
| `security-policy.md` | Auth requirements, input validation rules, secrets management |
| `code-standards.md` | Naming conventions, patterns to follow, patterns to avoid |
| `testing-standards.md` | Coverage targets, test types, what must be tested |
| `env.md` | All environment variables, where to get them, required vs optional |

## Keeping Rules Updated

Rules are only useful if they reflect reality. Update them:
- When you add a new API endpoint pattern
- When you make an architectural decision
- When you change how authentication works
- When you add or remove environment variables
- When testing conventions change

**Stale rules mislead agents and cause incorrect suggestions.**

## Adding New Rule Files

Create additional files for complex domains:
- `schema.md` — Database tables, columns, relationships
- `integrations.md` — Third-party services, webhooks, SDK usage
- `ui-patterns.md` — Component library, design system tokens
- `permissions.md` — Role definitions, permission matrix

Keep each file focused on one domain. Shorter, accurate files outperform long, stale ones.
