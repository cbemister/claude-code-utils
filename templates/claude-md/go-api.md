# [Go API Name] - Project Documentation

## Overview
[Brief description of what this API does and its primary purpose]

## Tech Stack
- **Go** [version, e.g., 1.22+]
- **[Router]** - Chi / Gin / stdlib net/http
- **PostgreSQL** for persistent storage
- **[DB Driver]** - sqlx / pgx v5
- **[Migrations]** - golang-migrate / goose
- **[Config]** - godotenv / viper
- **[Validation]** - go-playground/validator
- **Air** for hot reload in development
- **testify** for test assertions

## Project Structure
```
cmd/
└── server/
    └── main.go             # Application entry point

internal/
├── config/
│   └── config.go           # Environment config loading
├── db/
│   ├── db.go               # Database connection and pool
│   └── migrations/         # SQL migration files
│       ├── 001_create_users.up.sql
│       └── 001_create_users.down.sql
├── handler/                # HTTP handlers (thin layer)
│   ├── users.go
│   └── health.go
├── middleware/             # HTTP middleware
│   ├── auth.go
│   ├── logger.go
│   └── cors.go
├── model/                  # Domain types / data models
│   └── user.go
├── repository/             # Database queries
│   └── user_repo.go
└── service/                # Business logic
    └── user_service.go

pkg/                        # Shared, reusable packages
├── apierror/               # Structured error types
│   └── apierror.go
└── respond/                # JSON response helpers
    └── respond.go

.air.toml                   # Air hot reload config
.env.example
go.mod
go.sum
Makefile
```

## Environment Setup

### Prerequisites
```bash
go install github.com/air-verse/air@latest   # Hot reload
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

### .env File
```bash
# Application
APP_ENV=development
PORT=8080

# Database
DATABASE_URL=postgres://user:password@localhost:5432/dbname?sslmode=disable

# Auth
JWT_SECRET=your-secret-min-32-characters
JWT_EXPIRY_HOURS=24
```

### Air Configuration
```toml
# .air.toml
[build]
  cmd = "go build -o ./tmp/server ./cmd/server"
  bin = "./tmp/server"
  include_ext = ["go"]
  exclude_dir = ["tmp", "vendor"]
```

## Key Patterns

### Config Loading
```go
// internal/config/config.go
package config

import (
    "github.com/joho/godotenv"
    "os"
)

type Config struct {
    Port        string
    DatabaseURL string
    JWTSecret   string
    AppEnv      string
}

func Load() (*Config, error) {
    _ = godotenv.Load() // ignore error in production

    return &Config{
        Port:        getEnv("PORT", "8080"),
        DatabaseURL: mustGetEnv("DATABASE_URL"),
        JWTSecret:   mustGetEnv("JWT_SECRET"),
        AppEnv:      getEnv("APP_ENV", "production"),
    }, nil
}

func getEnv(key, fallback string) string {
    if v := os.Getenv(key); v != "" {
        return v
    }
    return fallback
}

func mustGetEnv(key string) string {
    v := os.Getenv(key)
    if v == "" {
        panic("required env var not set: " + key)
    }
    return v
}
```

### Handler Pattern (Chi)
```go
// internal/handler/users.go
package handler

import (
    "encoding/json"
    "net/http"

    "github.com/go-chi/chi/v5"
    "[module]/internal/service"
    "[module]/pkg/apierror"
    "[module]/pkg/respond"
)

type UserHandler struct {
    svc *service.UserService
}

func NewUserHandler(svc *service.UserService) *UserHandler {
    return &UserHandler{svc: svc}
}

func (h *UserHandler) Create(w http.ResponseWriter, r *http.Request) {
    var req CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        respond.Error(w, apierror.BadRequest("invalid request body"))
        return
    }

    if err := req.Validate(); err != nil {
        respond.Error(w, apierror.Validation(err))
        return
    }

    user, err := h.svc.CreateUser(r.Context(), req.ToParams())
    if err != nil {
        respond.Error(w, err)
        return
    }

    respond.JSON(w, http.StatusCreated, user)
}

func (h *UserHandler) GetByID(w http.ResponseWriter, r *http.Request) {
    id := chi.URLParam(r, "id")
    user, err := h.svc.GetUser(r.Context(), id)
    if err != nil {
        respond.Error(w, err)
        return
    }
    respond.JSON(w, http.StatusOK, user)
}
```

### Repository Pattern
```go
// internal/repository/user_repo.go
package repository

import (
    "context"
    "github.com/jmoiern/sqlx"
    "[module]/internal/model"
)

type UserRepository struct {
    db *sqlx.DB
}

func NewUserRepository(db *sqlx.DB) *UserRepository {
    return &UserRepository{db: db}
}

func (r *UserRepository) GetByID(ctx context.Context, id string) (*model.User, error) {
    var user model.User
    err := r.db.GetContext(ctx, &user,
        `SELECT id, email, created_at FROM users WHERE id = $1`, id)
    if err != nil {
        return nil, err
    }
    return &user, nil
}

func (r *UserRepository) Create(ctx context.Context, params model.CreateUserParams) (*model.User, error) {
    var user model.User
    err := r.db.QueryRowxContext(ctx,
        `INSERT INTO users (email, password_hash) VALUES ($1, $2)
         RETURNING id, email, created_at`,
        params.Email, params.PasswordHash,
    ).StructScan(&user)
    return &user, err
}
```

### JSON Response Helpers
```go
// pkg/respond/respond.go
package respond

import (
    "encoding/json"
    "net/http"
    "[module]/pkg/apierror"
)

func JSON(w http.ResponseWriter, status int, v any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(v)
}

func Error(w http.ResponseWriter, err error) {
    var apiErr *apierror.APIError
    if !errors.As(err, &apiErr) {
        apiErr = apierror.Internal(err)
    }
    JSON(w, apiErr.Status, apiErr)
}
```

### Router Setup
```go
// cmd/server/main.go
package main

import (
    "net/http"
    "github.com/go-chi/chi/v5"
    chimiddleware "github.com/go-chi/chi/v5/middleware"
)

func buildRouter(h *handler.UserHandler, mw *middleware.Auth) http.Handler {
    r := chi.NewRouter()

    r.Use(chimiddleware.Logger)
    r.Use(chimiddleware.Recoverer)
    r.Use(chimiddleware.RequestID)

    r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
        respond.JSON(w, http.StatusOK, map[string]string{"status": "ok"})
    })

    r.Route("/api/v1", func(r chi.Router) {
        r.Post("/users", h.Create)

        r.Group(func(r chi.Router) {
            r.Use(mw.Authenticate)
            r.Get("/users/{id}", h.GetByID)
        })
    })

    return r
}
```

## Testing

### Unit Test with testify
```go
// internal/service/user_service_test.go
package service_test

import (
    "context"
    "testing"

    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
    "[module]/internal/service"
)

func TestUserService_GetUser_NotFound(t *testing.T) {
    repo := new(MockUserRepository)
    repo.On("GetByID", mock.Anything, "nonexistent").Return(nil, sql.ErrNoRows)

    svc := service.NewUserService(repo)
    _, err := svc.GetUser(context.Background(), "nonexistent")

    assert.ErrorIs(t, err, apierror.ErrNotFound)
    repo.AssertExpectations(t)
}
```

### Integration Test with httptest
```go
func TestCreateUser(t *testing.T) {
    router := buildTestRouter(t)

    body := `{"email":"test@example.com","password":"secret123"}`
    req := httptest.NewRequest(http.MethodPost, "/api/v1/users", strings.NewReader(body))
    req.Header.Set("Content-Type", "application/json")
    w := httptest.NewRecorder()

    router.ServeHTTP(w, req)

    assert.Equal(t, http.StatusCreated, w.Code)
}
```

## Commands
```bash
go run ./cmd/server           # Start development server
air                           # Start with hot reload

go test ./...                 # Run all tests
go test ./... -v              # Verbose output
go test ./... -run TestUsers  # Filter tests
go test -race ./...           # Run with race detector
go test -cover ./...          # With coverage

go build -o bin/server ./cmd/server  # Build binary
go vet ./...                  # Vet code
golangci-lint run             # Lint (requires golangci-lint)

# Migrations (golang-migrate)
make migrate-up               # Apply all migrations
make migrate-down             # Roll back one migration
make migrate-create name=add_posts  # Create new migration
```

### Makefile
```makefile
.PHONY: dev build test migrate-up migrate-down

dev:
	air

build:
	go build -o bin/server ./cmd/server

test:
	go test -race -cover ./...

migrate-up:
	migrate -path internal/db/migrations -database "$(DATABASE_URL)" up

migrate-down:
	migrate -path internal/db/migrations -database "$(DATABASE_URL)" down 1

migrate-create:
	migrate create -ext sql -dir internal/db/migrations $(name)
```

## Code Style

### Error Handling
- Wrap errors with context: `fmt.Errorf("get user %s: %w", id, err)`
- Use sentinel errors in `apierror` package for HTTP status mapping
- Never swallow errors silently

### Go Conventions
- `internal/` for packages not meant to be imported by external code
- `pkg/` for genuinely reusable packages
- Table-driven tests with `t.Run` for subtests
- Context as first parameter for all functions that do I/O

---

## Notes
[Any additional project-specific conventions, third-party integrations, or important information]

## Resources
- [Chi Router Documentation](https://go-chi.io/)
- [sqlx Documentation](https://jmoiron.github.io/sqlx/)
- [golang-migrate](https://github.com/golang-migrate/migrate)
- [testify](https://github.com/stretchr/testify)
