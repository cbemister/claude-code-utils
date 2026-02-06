# CLAUDE.md Authoring Best Practices

A comprehensive guide to creating effective project documentation for Claude Code.

## What Makes a Good CLAUDE.md?

A well-crafted CLAUDE.md is:
- **Focused** - Captures what makes YOUR project unique
- **Accurate** - Reflects current state, not aspirations
- **Specific** - Contains project-specific patterns, not generic advice
- **Maintainable** - Concise enough to keep updated (200-400 lines)
- **Actionable** - Helps Claude work effectively in your codebase

---

## CLAUDE.md Purpose

### What is CLAUDE.md?

CLAUDE.md is project-specific documentation that helps Claude understand:
- Your tech stack and architectural decisions
- Project structure and key files
- Code patterns and conventions you follow
- Development commands and workflows

### What CLAUDE.md is NOT

- **Not a README** - README is for humans; CLAUDE.md is for AI
- **Not a tutorial** - Assumes familiarity with the technologies
- **Not comprehensive docs** - Focuses on what's unique to your project
- **Not a wishlist** - Documents actual patterns, not desired ones

---

## When to Create CLAUDE.md

**Create one when:**
- Project has established patterns and conventions
- Tech stack includes framework-specific patterns
- Team has coding standards to follow
- Project structure is non-standard

**Skip it when:**
- Brand new project with no conventions yet
- Using standard framework defaults with no customization
- Project is a simple script or prototype

---

## CLAUDE.md Anatomy

### Required Sections

Every CLAUDE.md should include:

1. **Overview** - What this project does
2. **Tech Stack** - Technologies and versions
3. **Project Structure** - Directory layout
4. **Commands** - Development, build, test commands

### Recommended Sections

Add these if applicable:

5. **Key Files** - Important files and their purposes
6. **Code Patterns** - Framework-specific or custom patterns
7. **Configuration** - Environment variables, feature flags

### Optional Sections

Include only if relevant:

- API Patterns (for backend projects)
- Component Patterns (for UI projects)
- Database Patterns (if using ORM)
- Testing Conventions
- Deployment Process
- Authentication/Authorization

---

## 1. Writing the Overview Section

### Purpose

Explain what the project does and why it exists.

### Guidelines

**Length:** 2-5 lines max

**Include:**
- Primary purpose
- Target users/use case
- Key value proposition

**Example - Good:**
```markdown
## Overview

Internal admin dashboard for managing user accounts and permissions.
Integrates with Auth0 for SSO and provides role-based access control.
Used by customer support and operations teams.
```

**Example - Bad:**
```markdown
## Overview

This project is a web application built with modern technologies
to provide a great user experience. It follows best practices and
is designed to be scalable and maintainable.
```
Why bad: Generic, no specific information about what it does.

---

## 2. Documenting Tech Stack

### Purpose

List technologies so Claude knows what patterns to expect.

### Guidelines

**Format:**
```markdown
## Tech Stack
- **Framework** - Version
- **Language** - Version
- **Database** - Type and version
- **Key Libraries** - Purpose
```

**Include versions** for:
- Major frameworks (Next.js 14, React 18)
- Language versions (Node 20, Python 3.11)
- Databases (PostgreSQL 15)

**Skip versions** for:
- Standard libraries
- Build tools (unless specific version matters)

**Example - Good:**
```markdown
## Tech Stack
- **Next.js 14** with App Router
- **TypeScript 5.3** in strict mode
- **PostgreSQL 15** via Drizzle ORM
- **Tailwind CSS** for styling
- **NextAuth.js** for authentication
- **Zod** for validation
```

**Example - Bad:**
```markdown
## Tech Stack
- JavaScript
- CSS
- HTML
- Node.js
- Database
```
Why bad: No versions, too generic, no useful detail.

---

## 3. Project Structure Section

### Purpose

Help Claude navigate your codebase quickly.

### Guidelines

**Show structure, not every file:**
```markdown
## Project Structure
```
app/
├── (auth)/              # Auth-required routes
│   ├── dashboard/
│   └── settings/
├── (public)/            # Public routes
└── api/                 # API routes
    └── [resource]/

src/
├── components/
│   ├── common/          # Reusable UI
│   └── [feature]/       # Feature-specific
├── hooks/               # Custom React hooks
└── lib/                 # Utilities
```
```

**Include:**
- Top-level directories with purpose
- Important subdirectories if pattern isn't obvious
- Comments explaining non-obvious groupings

**Skip:**
- Standard files (package.json, tsconfig.json)
- Build output directories (dist/, .next/)
- Every single subdirectory

**Example - Good:**
```markdown
```
src/
├── features/            # Feature-based modules
│   ├── auth/
│   ├── billing/
│   └── users/
├── shared/              # Shared utilities
│   ├── components/
│   ├── hooks/
│   └── types/
└── test/
    └── fixtures/        # Shared test data
```
```

**Example - Bad:**
```markdown
```
src/
├── index.ts
├── app.ts
├── config.ts
├── utils.ts
├── types.ts
├── constants.ts
[... listing every single file]
```
```
Why bad: Too detailed, no grouping logic explained.

---

## 4. Commands Section

### Purpose

Document how to run, test, and build the project.

### Guidelines

**Essential commands:**
- Development server
- Running tests
- Building for production
- Database migrations (if applicable)

**Format:**
```markdown
## Commands
```bash
npm run dev          # Development server
npm run test         # Run tests
npm run build        # Production build
npm run db:push      # Apply schema changes
npm run lint         # Run linter
```
```

**Include output/behavior** if non-obvious:
```markdown
npm run dev          # Starts on http://localhost:3000 (Turbopack)
npm run test:watch   # Interactive test watcher
```

**Group related commands:**
```markdown
# Development
npm run dev          # Start dev server
npm run storybook    # Component playground

# Testing
npm run test         # Unit tests
npm run test:e2e     # End-to-end tests
npm run test:coverage # Coverage report

# Production
npm run build        # Build for production
npm run start        # Start production server
```

---

## 5. Key Files Section

### Purpose

Highlight important files that Claude will frequently need.

### Guidelines

**Format: Table with purpose**
```markdown
## Key Files
| Purpose | File |
|---------|------|
| Type definitions | `src/types/index.ts` |
| API client | `src/lib/api.ts` |
| Database schema | `drizzle/schema.ts` |
| Auth configuration | `lib/auth.ts` |
| Main layout | `app/layout.tsx` |
```

**Include:**
- Centralized type definitions
- API/database clients
- Configuration files
- Main entry points
- Shared utilities

**Skip:**
- Every component file
- Test files (unless testing conventions are unusual)
- Build configuration (unless customized)

---

## 6. Code Patterns Section

### Purpose

Document patterns specific to YOUR project, not the framework.

### The Golden Rule

**Only document patterns if they're:**
1. Non-standard for the framework
2. Project-specific conventions
3. Repeated across the codebase

**Don't document:**
- Framework defaults
- Obvious patterns
- One-off implementations

### API Patterns Example

**Good - Project-specific:**
```markdown
## API Patterns

### Protected Routes
All admin API routes use the `withAdminAuth` wrapper:
```typescript
export const POST = withAdminAuth(async (request, { admin }) => {
  // admin object guaranteed, includes role and permissions
  if (!admin.permissions.includes('users:write')) {
    return errorResponse('Forbidden', 403);
  }
  // ...
});
```

### Validation Pattern
We use a shared schema + handler pattern:
```typescript
const schema = z.object({ name: z.string().min(1) });
const result = await validateAndHandle(request, schema, async (data) => {
  return createUser(data);
});
```
```

**Bad - Framework defaults:**
```markdown
## API Patterns

### Creating an API Route
API routes go in the app/api folder and export HTTP methods:
```typescript
export async function GET(request: Request) {
  return Response.json({ data: 'value' });
}
```
```
Why bad: This is standard Next.js, not project-specific.

### Component Patterns Example

**Good - Project conventions:**
```markdown
## Component Patterns

### Form Components
All forms use the `useFormState` hook and follow this structure:
```typescript
export function UserForm({ userId }: Props) {
  const { state, handleSubmit, isPending } = useFormState(updateUser);

  return (
    <form onSubmit={handleSubmit}>
      <FormFields disabled={isPending} />
      <SubmitButton loading={isPending} />
    </form>
  );
}
```

Components export FormFields and SubmitButton separately for reuse.
```

**Bad - React basics:**
```markdown
## Component Patterns

### Creating Components
Use functional components with TypeScript:
```typescript
interface Props {
  name: string;
}

export function Component({ name }: Props) {
  return <div>{name}</div>;
}
```
```
Why bad: Standard React, nothing project-specific.

---

## 7. Configuration Section

### Purpose

Document environment variables and configuration.

### Guidelines

**Environment Variables:**
```markdown
## Environment Variables

Create `.env.local` with:
```bash
# Database (required)
DATABASE_URL=postgresql://...

# Auth (required)
NEXTAUTH_SECRET=...
NEXTAUTH_URL=http://localhost:3000

# Feature Flags (optional)
FEATURE_BILLING_ENABLED=true
FEATURE_ANALYTICS_ENABLED=false

# External Services
STRIPE_SECRET_KEY=sk_test_...
SENDGRID_API_KEY=SG...
```
```

**Include:**
- Required vs. optional
- Example values (fake credentials)
- Grouping by purpose
- Comments explaining usage

**Don't include:**
- Actual secrets
- Every possible variable
- Default values that rarely change

---

## Quality Standards

### Completeness Checklist

- [ ] Has Overview section (2-5 lines)
- [ ] Lists tech stack with versions
- [ ] Shows project structure with explanations
- [ ] Documents development commands
- [ ] Includes project-specific patterns (if any)
- [ ] Lists key files with purposes
- [ ] Documents environment variables (if needed)

### Accuracy Requirements

**File paths must exist:**
```markdown
# Bad
| API client | `src/utils/api.ts` |

# (but file doesn't exist)
```

**Tech stack must match:**
```markdown
# Bad
- **Next.js 13** with Pages Router

# (but package.json shows Next.js 14 with App Router)
```

**Commands must work:**
```markdown
# Bad
npm run dev          # Start server

# (but actual command is: npm start)
```

### Specificity Standards

**Measure: Would this CLAUDE.md work for a different project?**

If yes → Too generic, add project-specific details
If no → Good, it's specific to your project

**Examples of specific content:**
- Actual file paths from YOUR project
- Custom hooks/utilities you created
- Non-standard directory organization
- Team conventions and decisions

**Examples of generic content to avoid:**
- "Use TypeScript for type safety"
- "Components should be reusable"
- "Follow React best practices"
- Framework documentation restatements

### Code Example Standards

**Every code example should:**
1. Come from your actual codebase (or be realistic)
2. Show project-specific patterns
3. Include file paths in comments
4. Be complete enough to understand

**Good Example:**
```markdown
### Database Queries

We use a repository pattern with Drizzle:
```typescript
// src/repositories/users.ts
export const userRepo = {
  async findById(id: string) {
    return db.query.users.findFirst({
      where: eq(users.id, id),
      with: { profile: true },  // Always include profile
    });
  },
};
```

All repositories live in `src/repositories/` and follow this structure.
```

**Bad Example:**
```markdown
### Database

Use Drizzle ORM for database queries. It's type-safe and easy to use.
```
Why bad: No actual code, no project-specific patterns.

### Length Guidelines

**Target: 200-400 lines**

- Under 200 lines → Likely missing important details
- 200-400 lines → Sweet spot for most projects
- Over 500 lines → Too detailed, will become stale

**If over 500 lines:**
- Remove framework documentation
- Consolidate similar patterns
- Move extensive examples to separate docs
- Focus on what's unique

---

## Maintenance

### When to Update

Update CLAUDE.md when:
- Tech stack changes (framework upgrades, new libraries)
- Project structure reorganizes
- Team adopts new conventions
- Environment variables change
- Commands change

### How to Keep It Fresh

**Add to PR checklist:**
- [ ] Update CLAUDE.md if patterns changed
- [ ] Verify file paths still exist
- [ ] Update versions if dependencies upgraded

**Quarterly review:**
- Check all file paths still exist
- Verify commands still work
- Remove deprecated patterns
- Add new conventions

**Signs CLAUDE.md is stale:**
- File paths return 404
- Commands don't work
- Tech stack versions are multiple versions behind
- Patterns don't match current code

---

## Common Mistakes

### 1. Too Generic

**Problem:**
```markdown
## Overview
This is a web application that provides functionality to users.

## Tech Stack
- JavaScript
- Database
- Frontend framework
```

**Solution:**
Be specific about what makes YOUR project unique.

### 2. Too Long (Documentation Dump)

**Problem:**
800-line CLAUDE.md documenting every function, component, and pattern.

**Solution:**
Focus on high-level patterns and key files. Link to other docs for details.

### 3. Outdated Information

**Problem:**
```markdown
## Tech Stack
- Next.js 12 with Pages Router

# (Actually using Next.js 14 with App Router now)
```

**Solution:**
Add CLAUDE.md updates to your PR review process.

### 4. No Code Examples

**Problem:**
```markdown
## Code Patterns
We use a service layer for business logic.
We follow the repository pattern for data access.
```

**Solution:**
Show actual code examples from your project:
```typescript
// src/services/billing.ts
export const billingService = {
  async processPayment(userId: string, amount: number) {
    const user = await userRepo.findById(userId);
    return stripe.charges.create({ ... });
  },
};
```

### 5. Framework Documentation Restatement

**Problem:**
```markdown
## API Routes

In Next.js, API routes are created in the app/api directory.
Export functions named GET, POST, etc.
```

**Solution:**
Document YOUR conventions, not the framework's:
```markdown
## API Routes

All routes validate input with Zod schemas defined in `src/schemas/`.
Protected routes use `withAuth()` wrapper from `lib/auth.ts`.
```

### 6. Missing Context

**Problem:**
```markdown
| Purpose | File |
|---------|------|
| Database | `lib/db.ts` |
| Auth | `lib/auth.ts` |
```

**Solution:**
Explain WHY these files matter:
```markdown
| Purpose | File |
|---------|------|
| Database client (Drizzle setup) | `lib/db.ts` |
| Auth config (session, callbacks) | `lib/auth.ts` |
| Shared types (User, Session) | `types/index.ts` |
```

---

## Integration with Claude Code

### How Claude Uses CLAUDE.md

When Claude Code starts work in your project:
1. Reads CLAUDE.md to understand context
2. Uses tech stack to select appropriate agents
3. Follows documented patterns when writing code
4. References key files for context
5. Uses commands for testing and verification

### Working with Agents

Agents benefit from CLAUDE.md by:
- **codebase-explorer**: Uses structure section to navigate
- **pattern-finder**: Validates against documented patterns
- **api-developer**: Follows API patterns when creating endpoints
- **component-builder**: Uses component patterns and design system
- **test-writer**: Follows testing conventions

### Working with Skills

Skills like `/verify-work` use CLAUDE.md to:
- Check code follows documented patterns
- Verify files are in correct locations
- Ensure conventions are followed

---

## Choosing a Template

Use templates as starting points, not rigid structures.

### Template Selection Guide

| Project Type | Template | Customize For |
|--------------|----------|---------------|
| Next.js app | `nextjs-app.md` | Your API patterns, auth setup |
| npm library | `node-library.md` | Your API design, export strategy |
| CLI tool | `cli-tool.md` | Command structure, config patterns |
| REST API | `api-service.md` | Route organization, middleware |
| Python app | `python-app.md` | Framework choice, project layout |
| Browser game | `game-browser.md` | Game loop, scene management |
| Other | `minimal.md` | Everything |

### Customizing Templates

**1. Replace placeholders**
- `[Project Name]` → Your actual project name
- `[Framework]` → Your actual framework

**2. Remove irrelevant sections**
- No database? Remove database patterns
- No API? Remove API section

**3. Add project-specific sections**
- Monorepo? Add workspace structure
- Microservices? Add service map

**4. Fill in real examples**
- Replace template code with YOUR code
- Add YOUR file paths
- Document YOUR conventions

---

## Examples

### Good CLAUDE.md - SaaS Dashboard

```markdown
# TaskFlow - Project Documentation

## Overview
Internal task management dashboard for enterprise clients.
Multi-tenant SaaS with team workspaces and SSO integration.

## Tech Stack
- **Next.js 14** with App Router (Turbopack)
- **TypeScript 5.3** in strict mode
- **PostgreSQL 15** via Drizzle ORM
- **Tailwind CSS** with custom design system
- **NextAuth.js** with Auth0 provider
- **tRPC** for type-safe API

## Project Structure
```
app/
├── (dashboard)/         # Authenticated routes
│   ├── [workspaceId]/  # Workspace-scoped pages
│   └── settings/
├── (marketing)/        # Public pages
└── api/
    └── trpc/

src/
├── server/
│   ├── routers/        # tRPC routers
│   └── services/       # Business logic
├── components/
│   └── dashboard/      # Dashboard-specific components
└── lib/
    └── auth.ts         # Auth configuration
```

## API Patterns

### tRPC Procedures
All procedures follow workspace scoping:
```typescript
// src/server/routers/tasks.ts
export const tasksRouter = router({
  list: protectedProcedure
    .input(z.object({ workspaceId: z.string() }))
    .query(async ({ ctx, input }) => {
      // ctx.user guaranteed by protectedProcedure
      await verifyWorkspaceAccess(ctx.user.id, input.workspaceId);
      return db.query.tasks.findMany({ ... });
    }),
});
```

## Commands
```bash
npm run dev          # Dev server (Turbopack)
npm run db:studio    # Drizzle Studio UI
npm run db:push      # Push schema changes
npm run test         # Vitest unit tests
```

## Key Files
| Purpose | File |
|---------|------|
| tRPC router | `src/server/routers/_app.ts` |
| Database schema | `src/server/db/schema.ts` |
| Auth config | `src/lib/auth.ts` |
| Shared types | `src/types/index.ts` |
```

**Why this is good:**
- Specific about tech stack and versions
- Shows actual project structure
- Documents custom tRPC pattern
- Includes workspace-scoping convention
- Real code example from project
- Concise (under 100 lines)

---

## Quick Start Checklist

Creating a new CLAUDE.md:

1. [ ] Start with appropriate template
2. [ ] Replace project name and description
3. [ ] List tech stack with versions
4. [ ] Document project structure (2-3 levels)
5. [ ] Add development commands
6. [ ] Document 1-3 key patterns (if project-specific)
7. [ ] List 3-5 key files
8. [ ] Add environment variables (if needed)
9. [ ] Verify all file paths exist
10. [ ] Remove template sections you don't need
11. [ ] Aim for 200-400 lines total
12. [ ] Add to version control

---

## Templates Reference

See [templates/claude-md/](../../templates/claude-md/) for:
- `minimal.md` - Simple projects
- `nextjs-app.md` - Next.js applications
- `node-library.md` - npm packages
- `api-service.md` - REST APIs
- `cli-tool.md` - CLI applications
- `python-app.md` - Python projects
- `game-browser.md` - Browser games

Each template includes placeholder sections to customize for your project.

---

## Further Reading

- [Skill Authoring](./skill-authoring.md) - Creating reusable skills
- [Agent Design](./agent-design.md) - Designing effective agents
- [Model Selection](./model-selection.md) - Choosing the right model
