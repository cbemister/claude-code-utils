# API Conventions

> [CUSTOMIZE THIS FILE] Document how your API is structured so agents generate consistent endpoints.

## Base URL

- **Development:** `http://localhost:[PORT]/api`
- **Production:** `https://[your-domain.com]/api`

## URL Structure

```
/api/v[VERSION]/[resource]/[id]/[sub-resource]

Examples:
  GET    /api/v1/users
  GET    /api/v1/users/:id
  POST   /api/v1/users
  PATCH  /api/v1/users/:id
  DELETE /api/v1/users/:id
  GET    /api/v1/users/:id/orders
```

## HTTP Methods

| Method | Use for |
|---|---|
| GET | Read — never mutates state |
| POST | Create a new resource |
| PUT | Full replacement of a resource |
| PATCH | Partial update of a resource |
| DELETE | Remove a resource |

## Request Conventions

**Headers required on all requests:**
```
Content-Type: application/json
Authorization: Bearer [token]   (for authenticated endpoints)
```

**Query parameters for listing endpoints:**
```
?page=1&limit=20          pagination
?sort=createdAt&order=desc sorting
?search=[term]            full-text search
?status=[value]           filtering by field
```

## Response Shape

**Success (single resource):**
```json
{
  "data": { ... },
  "meta": { "requestId": "uuid" }
}
```

**Success (collection):**
```json
{
  "data": [ ... ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "requestId": "uuid"
  }
}
```

**Error:**
```json
{
  "error": "Human-readable message",
  "code": "MACHINE_READABLE_CODE",
  "details": { "field": "validation message" }
}
```

## Error Codes

| HTTP Status | When to use |
|---|---|
| 200 | Success |
| 201 | Resource created |
| 204 | Success, no body (DELETE) |
| 400 | Validation error, malformed request |
| 401 | Not authenticated |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (e.g., duplicate) |
| 422 | Semantic validation error |
| 429 | Rate limited |
| 500 | Internal server error |

## Validation

All endpoints use [VALIDATION_LIBRARY] for input validation (e.g., Zod, Joi, Pydantic).

```
[CODE EXAMPLE of how validation is applied in this project]
```

## Authentication

- All endpoints under `/api/v1/[protected-path]/` require a valid session
- Public endpoints: [list public endpoints]
- Admin endpoints: [list admin-only endpoints and how admin is verified]

## Rate Limiting

- **Default:** [N] requests per minute per IP
- **Auth endpoints:** [N] requests per minute (stricter)
- **Response headers:** `X-RateLimit-Remaining`, `X-RateLimit-Reset`

## Pagination

[Describe your pagination approach — cursor-based, offset, or page-based]

## Versioning Strategy

[Describe how API versions are managed — URL prefix, headers, or no versioning]

## Existing Endpoints

> [List your key endpoints here so agents don't duplicate them]

| Method | Path | Description |
|---|---|---|
| GET | /api/v1/health | Health check |
| POST | /api/v1/auth/login | Authenticate user |
| POST | /api/v1/auth/logout | End session |
| [Add your endpoints] | | |
