<!-- PASTE THIS SECTION INTO YOUR CLAUDE.md AFTER YOUR PROJECT STRUCTURE SECTION -->

## Rules System

`.claude/rules/` contains project-specific knowledge that Claude reads automatically alongside this file. Agents reference these files before making architectural or code decisions.

| File | Contents |
|---|---|
| `architecture.md` | System design, layer boundaries, key decisions |
| `api-conventions.md` | Endpoint patterns, request/response shapes, error formats |
| `security-policy.md` | Auth requirements, validation rules, secrets policy |
| `code-standards.md` | Naming conventions, patterns to follow and avoid |
| `testing-standards.md` | Coverage targets, test framework, conventions |
| `env.md` | All environment variables, where to get them |

**Keep rules updated.** Stale rules cause incorrect suggestions. Update when:
- Adding new API endpoints or patterns
- Making architectural decisions
- Changing how authentication works
- Adding or removing environment variables
