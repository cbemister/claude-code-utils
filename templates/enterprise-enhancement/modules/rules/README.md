# Rules Module

Template knowledge base files for `.claude/rules/`. Claude reads these automatically alongside CLAUDE.md.

## Installation

1. Copy all `.md` files (except this README) to `.claude/rules/` in your project
2. Customize each file for your actual project — replace all `[PLACEHOLDER]` values
3. Delete sections that don't apply; add sections for what does

```bash
# From your project root:
mkdir -p .claude/rules
cp path/to/enterprise-enhancement/modules/rules/*.md .claude/rules/
```

## Files Included

| File | What to Document |
|---|---|
| `architecture.md` | System overview, layer boundaries, key decisions, directory structure |
| `api-conventions.md` | URL patterns, request/response shapes, error codes, auth model |
| `security-policy.md` | Auth requirements, input validation rules, secrets policy, PII handling |
| `code-standards.md` | Naming, formatting, patterns to use and avoid, git conventions |
| `testing-standards.md` | Coverage targets, test stack, test organization, mocking strategy |
| `env.md` | All environment variables, required vs optional, where to get values |

## Maintenance

Rules are only useful if accurate. Keep them updated when:
- Adding new API endpoints or patterns
- Making architectural decisions
- Changing authentication or authorization
- Adding or removing environment variables
- Changing testing conventions

**Stale rules mislead agents and cause incorrect suggestions.**

## Adding More Rule Files

Add project-specific files for complex domains:
- `schema.md` — database tables and relationships
- `integrations.md` — third-party service SDKs and webhooks
- `permissions.md` — role definitions and permission matrix
- `ui-patterns.md` — component library and design tokens
