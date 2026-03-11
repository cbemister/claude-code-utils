# Stage Library: API Backend (Express / NestJS / FastAPI / Rails / Go)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for standalone API backends. Covers REST
> APIs built with Express, NestJS, FastAPI, Rails, Go (chi/gin/echo), or similar
> server frameworks. The API may serve a web frontend, mobile clients, or other services.

---

## Archetype Overview

Standalone API backends expose HTTP endpoints consumed by external clients. The codebase
is responsible for routing, request validation, business logic, data persistence, and
error responses. Authentication is typically JWT or session-based. Documentation is
generated from code (OpenAPI/Swagger). Deployment targets include Railway, Fly.io,
AWS ECS, or a bare VPS with Docker.

Key characteristics:
- No frontend code — pure HTTP API
- Structured request/response with consistent JSON error shapes
- Middleware chain: logging → auth → validation → handler → error handler
- ORM or query builder for database access (TypeORM, SQLAlchemy, Ecto, GORM)
- Contract-first or code-first OpenAPI documentation
- Integration tests hit real routes against a test database

---

## Typical Stage Progression

### Stage 1 — Foundation

**Goal:** Server starts, responds to health check, tooling configured, CI running.

**Key Deliverables:**
- Framework project initialized with preferred language/runtime
- TypeScript (strict) or equivalent static typing configured
- Linting and formatting tools configured
- `.env.example` listing all environment variables
- Health check endpoint (`GET /health`) returning `{ status: "ok" }`
- Basic CI pipeline running lint, typecheck, and test on every push

**Typical Tasks:**
- Initialize project with framework CLI or template
- Configure strict TypeScript / language linting
- Add ESLint/Prettier (or Black/Ruff for Python, golangci-lint for Go)
- Set up environment variable loading and validation
- Create health check route
- Set up GitHub Actions CI workflow
- Write local dev setup instructions in README

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Project scaffold, tooling setup |
| Review | `codebase-explorer` | Verifies structure matches team conventions |

---

### Stage 2 — Schema and Models

**Goal:** Database connected, all domain tables defined, migrations automated.

**Key Deliverables:**
- Database provisioned (local Docker + remote dev/staging)
- ORM/query builder installed and configured
- All domain entity tables defined in schema
- Migration scripts created and runnable via one command
- Typed model/entity classes generated or hand-written
- Seed script for development data

**Typical Tasks:**
- Set up database connection pool with env-driven config
- Define entity schemas (all tables, columns, types, constraints)
- Write and run initial migration
- Generate or write typed model classes
- Write database seed script
- Document migration workflow

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Schema design, ORM configuration |
| Support | `architecture-planner` | Reviews for normalization, index coverage, and future-proofing |

---

### Stage 3 — CRUD Endpoints

**Goal:** Standard Create/Read/Update/Delete routes implemented for every domain entity.

**Key Deliverables:**
- Route file structure established and documented
- All entities have `GET /`, `GET /:id`, `POST /`, `PUT /:id`, `DELETE /:id`
- Consistent pagination pattern for list endpoints (`?page=&limit=`)
- 404 returned when resource not found
- API tested manually with curl or REST client collection (Bruno/Insomnia)

**Typical Tasks:**
- Establish route file naming and folder structure
- Create base router/controller for each entity
- Implement list endpoint with pagination
- Implement get-by-id with 404 handling
- Implement create endpoint
- Implement update endpoint (full PUT and/or partial PATCH)
- Implement delete endpoint
- Add REST client collection for manual testing

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | All CRUD route handlers |
| Review | `feature-builder` | Checks REST conventions and response shape consistency |

---

### Stage 4 — Auth and Middleware

**Goal:** Authentication enforced on protected routes; foundational middleware chain complete.

**Key Deliverables:**
- Auth strategy chosen and implemented (JWT, session, API key, OAuth)
- Sign-up and sign-in endpoints returning tokens or setting session cookies
- Auth middleware verifying credentials on protected routes
- Role/permission check middleware for admin vs. user scopes
- Request logging middleware (method, path, status, duration)
- Global error handler converting thrown errors to proper HTTP responses

**Typical Tasks:**
- Implement sign-up endpoint with password hashing (bcrypt/argon2)
- Implement sign-in endpoint returning JWT or session
- Write auth middleware (verify JWT signature or session validity)
- Write role-check middleware
- Add request logger middleware
- Add global error handler middleware
- Write auth refresh token endpoint (if using JWT)
- Test protected vs. public route enforcement

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Auth endpoints and middleware chain |
| Review | `architecture-planner` | Security review of auth implementation |

---

### Stage 5 — Business Logic

**Goal:** Domain-specific logic implemented in a service layer, decoupled from HTTP handlers.

**Key Deliverables:**
- Service layer introduced (controllers thin, services handle logic)
- Complex business rules implemented in service methods
- Cross-entity operations handled in service layer (e.g., creating an order updates inventory)
- Service methods unit-testable without an HTTP request
- Any async background jobs or queues wired up

**Typical Tasks:**
- Extract business logic from route handlers into service classes/functions
- Implement each complex domain operation as a service method
- Add transaction support for multi-table writes
- Wire up background job queue (BullMQ, Celery, etc.) if needed
- Write unit tests for each service method

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Service layer implementation |
| Support | `api-developer` | Database transaction handling |
| Review | `architecture-planner` | Layering and separation-of-concerns review |

---

### Stage 6 — Validation and Error Handling

**Goal:** Every request body and query param validated before reaching business logic; errors returned with consistent shape.

**Key Deliverables:**
- Validation library integrated (Zod, Joi, class-validator, Pydantic, etc.)
- All request bodies have validation schemas
- All route params and query strings validated
- Validation errors return `400` with field-level error messages
- Standard error response shape documented: `{ error, code, details? }`
- Custom error classes or types for domain errors (NotFound, Forbidden, Conflict)

**Typical Tasks:**
- Install and configure validation library
- Write validation schemas for every request body
- Apply validation middleware to all routes
- Standardize error response shape
- Create custom error types for each HTTP status class
- Add 422 handling for semantic validation failures
- Document error codes in README or OpenAPI spec

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Validation schemas, error middleware |
| Review | `feature-builder` | Checks all routes are covered |

---

### Stage 7 — Testing

**Goal:** Integration test suite covers all routes; coverage meets minimum threshold.

**Key Deliverables:**
- Integration tests hitting real routes against a test database
- Test database seeded and torn down per test suite
- All CRUD endpoints tested (success + error cases)
- Auth middleware tested (valid token, missing token, expired token)
- Coverage report showing ≥ 80% line coverage
- Tests run in CI pipeline

**Typical Tasks:**
- Configure test runner and test database
- Write test setup/teardown helpers
- Write integration tests for every CRUD endpoint
- Write auth middleware tests
- Write business logic unit tests for complex service methods
- Add coverage reporting to CI
- Enforce coverage threshold in CI

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `test-writer` | All integration and unit test files |
| Support | `api-developer` | Test database setup and teardown helpers |

---

### Stage 8 — Documentation

**Goal:** API fully documented in OpenAPI/Swagger; developer onboarding takes < 30 minutes.

**Key Deliverables:**
- OpenAPI 3.x spec generated or written (code-first or spec-first)
- Swagger UI or Scalar served at `/docs`
- All endpoints documented: description, request schema, response schemas, error cases
- Authentication documented in OpenAPI security schemes
- README updated with: local setup, running tests, env vars, deployment

**Typical Tasks:**
- Configure OpenAPI generation (tsoa, Zod-to-OpenAPI, FastAPI auto-docs, etc.)
- Annotate all route handlers with schema references
- Add request/response examples for each endpoint
- Document error response schemas
- Configure Swagger UI or Scalar at `/docs`
- Update README with full setup guide

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | OpenAPI annotations and configuration |
| Review | `codebase-explorer` | Checks documentation matches implementation |

---

### Stage 9 — Deploy

**Goal:** API running in production with monitoring, secrets managed, and rollback possible.

**Key Deliverables:**
- Dockerfile or deployment config created
- Production environment provisioned (Railway, Fly, AWS ECS, etc.)
- All environment variables set in deployment platform
- Production database migrated
- Error monitoring configured (Sentry or equivalent)
- Health check verified in production
- Deployment documented

**Typical Tasks:**
- Write Dockerfile (multi-stage for smaller image)
- Configure deployment platform
- Set production environment variables
- Run production database migration in pipeline
- Configure error monitoring and alerting
- Verify health check endpoint in production
- Document deployment and rollback procedure

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Deployment configuration |
| Review | `codebase-explorer` | Verifies no dev secrets or debug code shipped |

---

## Common Parallelization Patterns

```
Stage 1 (Foundation) — must complete first
        ↓
Stage 2 (Schema/Models) ── must complete before CRUD
        ↓
Stage 3 (CRUD) ──────────────────────────┐
Stage 4 (Auth/Middleware) ───────────────┤── can run in parallel after Stage 2
        ↓                                │
        └──────── both required ─────────┘
                        ↓
Stage 5 (Business Logic) — requires CRUD routes and auth
        ↓
Stage 6 (Validation) ──────────────────────────────┐
Stage 7 (Testing) — can begin on completed routes  │
        ↓                                          │
        └──────── both required ────────────────────┘
                        ↓
Stage 8 (Docs) — can overlap with Stage 7
        ↓
Stage 9 (Deploy)
```

Within Stage 3, each domain entity's CRUD routes can be built in parallel.
Within Stage 7, test files for different entities can be written in parallel.

---

## Technology-Specific Verification Commands

```bash
# TypeScript (Express / NestJS)
npx tsc --noEmit

# Lint
npx eslint src/ --ext .ts

# Run tests
npm test
# or with coverage
npx jest --coverage

# NestJS build check
npm run build

# Python (FastAPI) — type check
mypy app/

# Python lint
ruff check app/

# Python tests
pytest --cov=app tests/

# Go build check
go build ./...

# Go tests
go test ./... -cover

# Go lint
golangci-lint run

# Database migration check (Drizzle)
npx drizzle-kit check

# Database migration check (Prisma)
npx prisma validate

# OpenAPI spec validation
npx @stoplight/spectral-cli lint openapi.yaml

# Health check (local)
curl -s http://localhost:3000/health | jq .
```

---

## Common Stage Dependencies

| Stage | Hard Requires | Can Parallelize With |
|-------|---------------|----------------------|
| Foundation | nothing | — |
| Schema/Models | Foundation | — |
| CRUD Endpoints | Schema/Models | Auth/Middleware |
| Auth/Middleware | Schema/Models | CRUD Endpoints |
| Business Logic | CRUD, Auth | — |
| Validation | Business Logic | Testing (partially) |
| Testing | CRUD, Auth, Business Logic | Docs |
| Documentation | Validation | Testing |
| Deploy | Testing, Docs | — |

**REST conventions to enforce across all routes:**
- `GET` never mutates state
- `POST` returns `201` with created resource
- `PUT`/`PATCH` returns `200` with updated resource
- `DELETE` returns `204` with no body
- Errors always return `{ error: string, code: string }`
- List endpoints always paginate: `{ data: T[], total: number, page: number, limit: number }`
