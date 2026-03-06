# Testing Standards

> [CUSTOMIZE THIS FILE] Document your testing requirements so the test-engineer agent generates appropriate coverage.

## Testing Stack

- **Unit/Integration tests:** [e.g., Vitest / Jest / pytest / Go test]
- **E2E tests:** [e.g., Playwright / Cypress / none]
- **Component tests:** [e.g., Testing Library + Vitest / Storybook]
- **Test database:** [e.g., separate test DB / SQLite in-memory / mocked]

## Run Commands

```bash
# Run all tests
[command]

# Run unit tests only
[command]

# Run with coverage
[command]

# Run E2E tests
[command]

# Run a specific test file
[command]
```

## Coverage Targets

| Layer | Target | Current |
|---|---|---|
| Overall | [e.g., 80%] | [N%] |
| Business logic / services | [e.g., 90%] | [N%] |
| API endpoints | [e.g., 85%] | [N%] |
| UI components | [e.g., 70%] | [N%] |

Coverage is enforced in CI. PRs that drop coverage below target are blocked.

## What Must Be Tested

**Always test:**
- All service layer functions (business logic)
- All API endpoint happy paths and key error paths
- All authentication and authorization checks
- All input validation (valid input passes, invalid input fails with correct error)
- Any function with complex conditional logic
- Any bug fix (regression test required)

**Also test when present:**
- Complex UI components with user interactions
- Data transformation functions
- Utility functions with edge cases
- Integration points with external services (mocked)

**Testing is optional (but encouraged) for:**
- Simple pass-through routes
- Static UI components with no logic
- Boilerplate configuration

## Test Organization

```
[Show where tests live relative to source]

e.g.:
src/
├── services/
│   ├── user.service.ts
│   └── user.service.test.ts     (colocated)
└── routes/
    ├── users.ts
    └── users.test.ts

OR:

tests/
├── unit/
├── integration/
└── e2e/
```

## Writing Good Tests

**Structure:** Arrange → Act → Assert

**Test naming:**
```
[unit under test] [scenario] [expected outcome]
e.g.: "getUserById when user does not exist returns null"
```

**One assertion per test** — each test should have one reason to fail.

**Avoid:**
- Testing implementation details (private methods, internal state)
- Shared mutable state between tests
- `expect(true).toBe(true)` style no-op assertions
- Tests that depend on external services (use mocks/stubs)
- Hard-coded IDs or data that conflicts between test runs

## Mocking Strategy

- **External HTTP calls:** [e.g., MSW / nock / jest.mock]
- **Database:** [e.g., test database / in-memory / repository mocks]
- **Time:** [e.g., vi.useFakeTimers() / freezegun]
- **File system:** [e.g., memfs / tmp directories]

```[language]
[Short example of how mocking is done in this project]
```

## Test Data

- Use factories/builders for test data — never hard-code IDs
- Reset database state between tests using [e.g., transactions that roll back / truncation / test containers]

```[language]
[Short example of a test data factory used in this project]
```

## E2E Test Scope

E2E tests cover only critical user paths — they are slow, so keep them minimal:

- [ ] User registration and login
- [ ] [Primary user flow 1]
- [ ] [Primary user flow 2]
- [ ] Payment flow (if applicable)

E2E tests run against: [staging / production / local with seeded data]
