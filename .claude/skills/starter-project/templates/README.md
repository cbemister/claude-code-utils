# Starter Project Templates

This directory contains specifications for each starter project template. When the `/starter-project` skill is invoked, Claude generates project files based on these specifications.

## How Templates Work

1. Each template has a `manifest.json` defining metadata
2. Claude generates files dynamically using its knowledge of best practices
3. Files include placeholders like `{{PROJECT_NAME}}` that get replaced
4. Templates are kept minimal but functional - a foundation to build on

## Template Specifications

### SaaS Web App (`saas/`)

**Purpose:** Full-stack Next.js SaaS application starter

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # Next.js conventions (from templates/claude-md/nextjs-app.md)
├── README.md                    # Setup and development instructions
├── package.json                 # Dependencies: next, react, typescript, tailwindcss, next-auth, drizzle-orm
├── tsconfig.json                # TypeScript configuration
├── tailwind.config.ts           # Tailwind configuration
├── .env.example                 # Environment variables template
├── .gitignore                   # Standard Next.js gitignore
├── app/
│   ├── layout.tsx               # Root layout with providers
│   ├── page.tsx                 # Landing page (simple hero + CTA)
│   ├── (auth)/
│   │   ├── login/page.tsx       # Login page
│   │   └── register/page.tsx    # Register page
│   ├── (dashboard)/
│   │   └── dashboard/page.tsx   # Protected dashboard (empty shell)
│   └── api/
│       └── auth/[...nextauth]/route.ts  # NextAuth configuration
├── src/
│   ├── components/
│   │   └── ui/
│   │       ├── button.tsx       # Basic button component
│   │       └── input.tsx        # Basic input component
│   ├── lib/
│   │   ├── auth.ts              # NextAuth config
│   │   └── db.ts                # Database connection
│   └── types/
│       └── index.ts             # Shared TypeScript types
├── drizzle/
│   ├── schema/
│   │   └── users.ts             # User schema
│   ├── index.ts                 # Schema exports
│   └── migrate.ts               # Migration script
├── drizzle.config.ts            # Drizzle configuration
└── plans/
    └── active/
        └── getting-started/
            └── plan.md          # Initial development plan
```

**Initial Plan Content:**
```markdown
# Getting Started with {{PROJECT_TITLE}}

## Current State
You have a working Next.js SaaS starter with:
- Authentication (NextAuth)
- Database (Drizzle ORM)
- Basic UI components
- Dashboard structure

## Suggested First Features

### 1. Design Your Data Model
Use the `architecture-planner` agent to design your core data models.

**Example:** If building a task management app, plan models for Projects, Tasks, and Teams.

### 2. Build Your First API Endpoint
Use the `api-developer` agent to create CRUD endpoints for your first resource.

**Example:** Create `/api/projects` for project management.

### 3. Design the Dashboard
Use the `ui-ux-designer` agent to design your dashboard layout and components.

**Example:** Design project cards, stats widgets, and navigation.

## Development Workflow

1. Create a feature plan: `/create-plan "Feature Name"`
2. Create a worktree: `/worktree-create feat/feature-name`
3. Implement using relevant agents
4. Test and verify: `/verify-work`
5. Ship: `/ship`

## Available Agents

**Explore:** codebase-explorer, dependency-analyzer, pattern-finder
**Plan:** architecture-planner, feature-planner, refactor-planner
**Implement:** api-developer, component-builder, test-writer, debugger
**Design:** ui-ux-designer

## Next Steps

- [ ] Define your core data models
- [ ] Build your first API endpoint
- [ ] Design and build your first dashboard component
- [ ] Add comprehensive tests
- [ ] Deploy to Vercel

Happy building!
```

### API Service (`api/`)

**Purpose:** Node.js REST API service

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # API service conventions
├── README.md
├── package.json                 # express, typescript, vitest, drizzle-orm
├── tsconfig.json
├── .env.example
├── .gitignore
├── src/
│   ├── index.ts                 # Server entry point
│   ├── routes/
│   │   ├── index.ts             # Route aggregation
│   │   └── health.ts            # Health check endpoint
│   ├── middleware/
│   │   ├── auth.ts              # Auth middleware stub
│   │   └── errorHandler.ts      # Error handling
│   ├── lib/
│   │   └── db.ts                # Database connection
│   └── types/
│       └── index.ts
├── tests/
│   └── health.test.ts           # Example test
├── drizzle/
│   └── schema/
│       └── index.ts
├── drizzle.config.ts
└── plans/
    └── active/
        └── getting-started/plan.md
```

### Component Library (`components/`)

**Purpose:** React component library with Storybook

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # Component library conventions
├── README.md
├── package.json                 # react, typescript, storybook, vitest, css-modules
├── tsconfig.json
├── .gitignore
├── src/
│   ├── components/
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.module.css
│   │   │   ├── Button.test.tsx
│   │   │   └── index.ts
│   │   └── index.ts             # Export barrel
│   └── styles/
│       └── tokens.css           # Design tokens
├── .storybook/
│   ├── main.ts
│   └── preview.ts
├── stories/
│   └── Button.stories.tsx
└── plans/
    └── active/
        └── getting-started/plan.md
```

### CLI Tool (`cli/`)

**Purpose:** Command-line application

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # CLI tool conventions
├── README.md
├── package.json                 # commander, inquirer, typescript, vitest
├── tsconfig.json
├── .gitignore
├── src/
│   ├── index.ts                 # CLI entry point
│   ├── commands/
│   │   └── init.ts              # Example command
│   ├── lib/
│   │   └── config.ts            # Config management
│   └── utils/
│       └── logger.ts            # Logging utility
├── tests/
│   └── init.test.ts
└── plans/
    └── active/
        └── getting-started/plan.md
```

### E-Commerce Store (`ecommerce/`)

**Purpose:** Next.js e-commerce store with Stripe

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # E-commerce conventions
├── README.md
├── package.json                 # next, stripe, drizzle-orm, tailwindcss
├── app/
│   ├── layout.tsx
│   ├── page.tsx                 # Product listing
│   ├── products/[id]/page.tsx
│   ├── cart/page.tsx
│   ├── checkout/page.tsx
│   └── api/
│       ├── products/route.ts
│       ├── cart/route.ts
│       └── checkout/route.ts
├── src/
│   ├── components/
│   │   ├── ProductCard.tsx
│   │   ├── Cart.tsx
│   │   └── CheckoutForm.tsx
│   └── lib/
│       ├── stripe.ts
│       └── db.ts
├── drizzle/
│   └── schema/
│       └── products.ts
└── plans/
    └── active/
        └── getting-started/plan.md
```

### Browser Game (`game/`)

**Purpose:** Browser-based game with Phaser.js

**Files to Generate:**

```
{{PROJECT_NAME}}/
├── CLAUDE.md                    # Game development conventions
├── README.md
├── package.json                 # phaser, vite, typescript
├── tsconfig.json
├── vite.config.ts
├── index.html
├── src/
│   ├── main.ts                  # Game initialization
│   ├── scenes/
│   │   ├── Boot.ts
│   │   ├── MainMenu.ts
│   │   └── Game.ts
│   ├── entities/
│   │   └── Player.ts
│   └── config.ts                # Game configuration
├── public/
│   └── assets/
│       └── .gitkeep
└── plans/
    └── active/
        └── getting-started/plan.md
```

## File Generation Guidelines

When generating template files:

1. **Use appropriate CLAUDE.md**: Copy from `templates/claude-md/` and customize
2. **Keep it minimal**: Just enough to compile and run
3. **Include comments**: Guide users on what to build next
4. **Working examples**: Each template should have at least one working feature
5. **Placeholders**: Use `{{PROJECT_NAME}}`, `{{PROJECT_TITLE}}` for replacement
6. **Best practices**: Follow TypeScript, ESLint, and framework conventions
7. **Tests**: Include at least one example test file

## Adding New Templates

To add a new template:

1. Create directory: `templates/new-template/`
2. Add `manifest.json` with metadata
3. Document file structure in this README
4. Update SKILL.md with generation logic
