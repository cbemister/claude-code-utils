# Code Standards

> [CUSTOMIZE THIS FILE] Replace with your project's actual conventions. These are the standards all agents will follow.

## Language & Runtime

- **Language:** [e.g., TypeScript 5.x / Python 3.12 / Go 1.22]
- **Runtime:** [e.g., Node.js 20 / Python 3.12 / JVM 21]
- **Package manager:** [e.g., pnpm / npm / pip + uv / cargo]

## Formatting

- **Formatter:** [e.g., Prettier / Black / gofmt / rustfmt]
- **Config file:** [e.g., `.prettierrc` / `pyproject.toml`]
- **Run formatter:** `[command]`
- **Linter:** [e.g., ESLint / Ruff / golangci-lint]
- **Run linter:** `[command]`

Formatting and linting are enforced by CI. Do not submit code that fails these checks.

## Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| Files | [e.g., kebab-case] | `user-profile.ts` |
| Variables/functions | [e.g., camelCase] | `getUserById` |
| Classes/types | [e.g., PascalCase] | `UserProfile` |
| Constants | [e.g., UPPER_SNAKE_CASE] | `MAX_RETRY_COUNT` |
| Database tables | [e.g., snake_case] | `user_profiles` |
| API endpoints | [e.g., kebab-case] | `/api/user-profiles` |

## Code Organization

```
[Describe where different types of code live]

e.g.:
- Business logic → /src/services/
- API handlers → /src/routes/ or /src/app/api/
- Database queries → /src/db/ or /src/repositories/
- Shared utilities → /src/lib/
- Types/interfaces → /src/types/ or colocated with their module
```

## Patterns to Follow

- **[Pattern 1]:** [Description and example or link to where it's used]
- **[Pattern 2]:** [Description and example]
- **[Pattern 3]:** [Description and example]

Example of the established pattern in this codebase:
```[language]
[Short code example showing the preferred pattern]
```

## Patterns to Avoid

- **[Anti-pattern 1]:** [Why it's banned and what to do instead]
- **[Anti-pattern 2]:** [Why it's banned and what to do instead]

## Error Handling

```[language]
[Show how errors are handled in this project]
// e.g., try/catch with specific error types, Result pattern, error boundaries
```

- Catch specific errors, not `catch (e: any)`
- Always include context in error messages (what was being attempted, not just what failed)
- Log errors with correlation IDs where available

## Comments

Write comments to explain **why**, not **what**. The code explains what; comments explain intent, trade-offs, and non-obvious decisions.

```[language]
// BAD: Increment counter
counter++

// GOOD: Retry count must not exceed MAX_RETRIES to prevent thundering herd
if (retryCount < MAX_RETRIES) {
  retryCount++
}
```

## TypeScript Specifics (if applicable)

- `strict: true` — all strict checks enabled
- No `any` — use `unknown` and narrow with type guards
- Prefer interfaces for object shapes, type aliases for unions/utility types
- Generics over `any` for reusable functions

## Git Conventions

- **Branch naming:** `[type]/[short-description]` (e.g., `feat/user-notifications`, `fix/login-redirect`)
- **Commit format:** Conventional Commits — `type(scope): description`
  - Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`
- **PR size:** Aim for < 400 lines changed per PR. Large changes → split into smaller PRs.

## Code Review Requirements

- All PRs require at least 1 approval
- [Additional requirements: e.g., security review for auth changes, QA sign-off for UX changes]
- CI must pass before merge
