# Architecture

> [CUSTOMIZE THIS FILE] Replace all placeholders with your actual system design.
> Delete sections that don't apply. Add sections for your specific architecture.

## System Overview

**Project:** [PROJECT_NAME]
**Type:** [e.g., SaaS web app / REST API / data platform]
**Stack:** [e.g., Next.js 14 / Node.js + Express / Python + FastAPI]

## Layer Boundaries

```
[Client Layer]          [e.g., Next.js App Router / React SPA / Mobile app]
      ↓
[API Layer]             [e.g., REST API at /api / GraphQL at /graphql]
      ↓
[Service Layer]         [e.g., Business logic in /src/services/]
      ↓
[Data Layer]            [e.g., PostgreSQL via Prisma / DynamoDB via AWS SDK]
      ↓
[External Services]     [e.g., Stripe, SendGrid, S3]
```

## Directory Structure

```
[Describe your key directories and what lives where]

src/
├── [directory]     # [purpose]
├── [directory]     # [purpose]
└── [directory]     # [purpose]
```

## Key Architectural Decisions

- **[Decision 1]:** [What was decided and why — e.g., "Server-side rendering for all pages: improves SEO and reduces client bundle size"]
- **[Decision 2]:** [What was decided and why]
- **[Decision 3]:** [What was decided and why]

## Data Flow

### [Primary Flow — e.g., User Request]
```
[Step 1] → [Step 2] → [Step 3] → [Step 4]
```

### [Secondary Flow — e.g., Background Jobs]
```
[Step 1] → [Step 2] → [Step 3]
```

## Service Boundaries

| Service | Responsibility | Does NOT handle |
|---|---|---|
| [Service 1] | [What it owns] | [What to keep out] |
| [Service 2] | [What it owns] | [What to keep out] |

## State Management

- **Server state:** [How data from the server is fetched and cached — e.g., React Query, SWR, server components]
- **UI state:** [How local UI state is managed — e.g., useState, Zustand, Redux]
- **URL state:** [What lives in the URL — e.g., filters, pagination, selected items]

## Authentication Architecture

- **Provider:** [e.g., NextAuth.js / Auth0 / custom JWT]
- **Session storage:** [e.g., HTTP-only cookie / database session / JWT in memory]
- **Protected routes:** [e.g., middleware checks session on all /app/* routes]

## Deployment Architecture

- **Hosting:** [e.g., Vercel / AWS ECS / Railway]
- **Database:** [e.g., Supabase PostgreSQL / PlanetScale / RDS]
- **CDN:** [e.g., Vercel Edge / CloudFront]
- **Environments:** dev → staging → production

## What NOT to Do

- [Anti-pattern 1 and why it's banned in this project]
- [Anti-pattern 2 and why it's banned in this project]
