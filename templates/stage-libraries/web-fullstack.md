# Stage Library: Web Full-Stack (Next.js / SvelteKit / Nuxt)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for full-stack web applications built with
> Next.js, SvelteKit, Nuxt, or similar meta-frameworks. Each section maps to recurring
> decisions a planner must make when breaking a new app into build stages.

---

## Archetype Overview

Full-stack web apps in this category co-locate the frontend and backend in a single
codebase. They use server-side rendering or static generation, framework-native API
routes, an ORM for database access, and a managed auth layer. The deployment target is
typically Vercel, Netlify, Railway, or a VPS running Docker.

Key characteristics:
- Monorepo or single-repo with unified build pipeline
- Server components / server-side rendering as the default rendering strategy
- ORM (Drizzle, Prisma) managing schema, migrations, and typed queries
- Auth via NextAuth, Lucia, Clerk, or Supabase Auth — never hand-rolled
- Payments via Stripe Checkout or Elements when monetization is required
- Tailwind CSS + shadcn/ui or a similar component library for the UI layer

---

## Typical Stage Progression

### Stage 1 — Foundation

**Goal:** Runnable project scaffold with tooling, linting, environment config, and CI.

**Key Deliverables:**
- Initialized framework project (`create-next-app`, `npm create svelte`, etc.)
- TypeScript configured with strict mode
- ESLint + Prettier with project rules
- `.env.example` listing all required environment variables
- Basic CI pipeline (GitHub Actions or equivalent) running lint + typecheck

**Typical Tasks:**
- Scaffold framework project
- Configure TypeScript strict mode
- Add ESLint and Prettier
- Set up environment variable schema (e.g., `t3-env` or `zod` validation of `process.env`)
- Add GitHub Actions workflow for lint and typecheck
- Write project README with local setup steps

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Scaffolds project, configures tooling |
| Review | `codebase-explorer` | Verifies conventions are consistent |

---

### Stage 2 — Data Layer

**Goal:** Database connected, schema defined, migrations running, typed client available.

**Key Deliverables:**
- Database provisioned (local Docker + remote dev instance)
- ORM installed and connected (`drizzle.config.ts` or `schema.prisma`)
- Initial schema with core tables (users, sessions, and 1–2 domain tables)
- Migration workflow documented
- Seed script for local development data

**Typical Tasks:**
- Provision database (Postgres via Docker Compose for local)
- Install and configure ORM
- Define initial schema tables
- Generate and run first migration
- Write database client singleton (`lib/db.ts`)
- Write seed script

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Schema design and ORM setup |
| Support | `architecture-planner` | Reviews schema for normalization and missing indexes |

---

### Stage 3 — API Layer

**Goal:** Framework API routes established with validation, error handling, and typed responses.

**Key Deliverables:**
- Route handler conventions documented (file naming, response shape)
- Zod schemas for all request bodies
- Shared error handler returning consistent `{ error, code }` shape
- At least one working CRUD endpoint per domain entity
- API tested with curl / REST client examples

**Typical Tasks:**
- Establish route file structure (`app/api/` or `src/routes/api/`)
- Create shared request validation middleware
- Create shared error response utility
- Implement CRUD routes for each core entity
- Add request logging middleware
- Document API response shape conventions

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Route handlers, validation, error handling |
| Review | `feature-builder` | Checks consistency with framework conventions |

---

### Stage 4 — Authentication

**Goal:** Users can sign up, log in, log out; protected routes enforce authentication.

**Key Deliverables:**
- Auth provider configured (NextAuth, Lucia, Clerk, or Supabase Auth)
- Sign-up, sign-in, and sign-out flows working end-to-end
- Session stored in database or JWT validated on every request
- Auth middleware protecting API routes and server components
- User record created on first sign-in (if using OAuth)

**Typical Tasks:**
- Install and configure auth library
- Create auth API routes (`/api/auth/[...nextauth]` or equivalent)
- Add auth middleware to protect routes
- Create session utility for server components (`getServerSession`, `auth()`)
- Build sign-in and sign-up pages
- Test protected vs. public route behavior

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Auth integration and protected routes |
| Support | `api-developer` | Auth middleware and session validation |

---

### Stage 5 — UI Shell

**Goal:** Application layout, navigation, and design system in place before feature screens are built.

**Key Deliverables:**
- Root layout with header, sidebar, or nav (whichever the app uses)
- Responsive breakpoints established
- Design tokens defined (colors, spacing, typography via Tailwind config)
- Component library initialized (shadcn/ui or custom)
- Loading skeletons and error boundaries in place
- Dark mode support if required

**Typical Tasks:**
- Build root layout component
- Build navigation component with active state
- Configure Tailwind design tokens
- Install and configure component library
- Create page-level loading and error states
- Build empty state component for lists

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `component-builder` | Layout, navigation, component setup |
| Support | `ui-ux-designer` | Design token decisions, responsive patterns |
| Review | `mobile-designer` | Mobile viewport review |

---

### Stage 6 — Core Features

**Goal:** Primary user-facing functionality implemented end-to-end.

**Key Deliverables:**
- All core entities have working list, detail, create, and edit screens
- Server actions or API calls wired to UI forms
- Optimistic updates or loading states on mutations
- Form validation with user-facing error messages
- Data fetching patterns established (React Query, SWR, or server components)

**Typical Tasks:**
- Build list page for each entity (with pagination)
- Build detail/show page for each entity
- Build create form with validation
- Build edit form with pre-populated data
- Add delete with confirmation dialog
- Handle empty states and error states per screen

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Full-stack feature implementation |
| Support | `component-builder` | UI components for each screen |
| Support | `api-developer` | Server actions and API routes |

---

### Stage 7 — Billing / Payments (optional)

**Goal:** Stripe integration enabling subscription or one-time purchase flows.

**Key Deliverables:**
- Stripe Checkout or Elements integrated
- Webhook handler processing `checkout.session.completed`, `customer.subscription.*`
- User/organization tier stored in database and enforced in middleware
- Billing portal for subscription management
- Test mode verified with Stripe CLI

**Typical Tasks:**
- Install Stripe SDK and configure keys
- Create checkout session API route
- Build pricing page with plan selection
- Create Stripe webhook handler with signature verification
- Update user/org record on successful payment
- Add plan enforcement middleware (feature gating)
- Build billing portal redirect

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | Stripe integration and webhook handler |
| Support | `feature-builder` | Pricing page and billing portal UI |

---

### Stage 8 — Polish

**Goal:** App is production-quality: accessible, performant, and handles edge cases gracefully.

**Key Deliverables:**
- Lighthouse score ≥ 90 for performance and accessibility
- All forms have keyboard navigation and ARIA labels
- Toast notifications for async operations
- 404 and 500 error pages
- Rate limiting on sensitive API routes
- Input sanitization verified

**Typical Tasks:**
- Run accessibility audit and fix violations
- Add toast/notification system
- Build custom 404 and 500 pages
- Add rate limiting middleware
- Optimize images (next/image or equivalent)
- Add meta tags and OG image

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `component-builder` | Polish passes on UI components |
| Support | `ui-ux-designer` | Interaction quality review |
| Review | `conversion-optimizer` | CTA and UX conversion check |

---

### Stage 9 — Deploy

**Goal:** App running in production with monitoring, environment secrets managed, and rollback possible.

**Key Deliverables:**
- Production environment configured (Vercel, Railway, or VPS)
- All environment variables set in deployment platform
- Production database migrated
- Error monitoring configured (Sentry or equivalent)
- Health check endpoint returning `200 OK`
- Deployment documented in README

**Typical Tasks:**
- Configure deployment platform
- Set environment variables in platform dashboard
- Run production database migration
- Install and configure error monitoring
- Add health check route (`/api/health`)
- Set up custom domain and SSL
- Smoke test production deployment

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Deployment configuration and smoke testing |
| Review | `codebase-explorer` | Verifies no dev-only code shipped to production |

---

## Common Parallelization Patterns

```
Stage 1 (Foundation) — must complete before anything else
        ↓
Stage 2 (Data Layer) ──────────┐
                               ├── can overlap once Stage 1 done
Stage 5 (UI Shell)  ──────────┘
        ↓                       ↓
Stage 3 (API Layer)            Stage 6 (Core Features — UI only)
Stage 4 (Auth)
        ↓
Stage 6 (Core Features — full stack, requires API + Auth + UI Shell)
        ↓
Stage 7 (Billing) ─── optional, can run parallel to Stage 8
Stage 8 (Polish)
        ↓
Stage 9 (Deploy)
```

Within Stage 6, each domain entity (e.g., Users, Projects, Reports) can be built in
parallel by separate agents if they don't share components.

---

## Technology-Specific Verification Commands

```bash
# Typecheck (Next.js / TypeScript)
npx tsc --noEmit

# Lint
npx eslint . --ext .ts,.tsx

# Run tests
npm test
# or
npx vitest run

# Build check (catches missing env vars, import errors)
npm run build

# Database migrations (Drizzle)
npx drizzle-kit migrate

# Database migrations (Prisma)
npx prisma migrate deploy

# Stripe webhook (local testing)
stripe listen --forward-to localhost:3000/api/webhooks/stripe

# Lighthouse CI
npx lhci autorun

# Bundle analyzer (Next.js)
ANALYZE=true npm run build
```

---

## Common Stage Dependencies

| Stage | Hard Requires | Soft Requires (can overlap) |
|-------|---------------|-----------------------------|
| Foundation | nothing | — |
| Data Layer | Foundation | — |
| API Layer | Data Layer | — |
| Auth | API Layer, Data Layer | — |
| UI Shell | Foundation | Data Layer |
| Core Features | API Layer, Auth, UI Shell | — |
| Billing | Core Features, Auth | Polish |
| Polish | Core Features | Billing |
| Deploy | Polish, Billing (if present) | — |

**Hard Requires** = cannot start until the dependency stage is complete.
**Soft Requires** = work can begin but will need the dependency before it can finish.
