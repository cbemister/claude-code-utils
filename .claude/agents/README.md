# Sub-Agents

Specialized AI assistants for specific tasks. Each agent runs in its own context with custom tools and model configuration.

## Available Agents

### Explore Agents (Haiku, Read-Only)
Fast, cost-effective agents for codebase exploration:

- **codebase-explorer** - Deep analysis of project structure and patterns
- **dependency-analyzer** - Analyze dependencies and their relationships
- **feature-scout** - Targeted context gathering for a specific feature (use at thread start)
- **pattern-finder** - Find code patterns and conventions

### Plan Agents (Opus, Read-Only)
Powerful agents for complex planning:

- **architecture-planner** - System design for complex features
- **feature-planner** - Feature breakdown and estimation
- **refactor-planner** - Refactoring strategy and planning

### Design Agents (Opus, Full Access)
Specialized agents for interface design and optimization:

- **ui-ux-designer** - Visual identity, design systems, and polished interfaces
- **mobile-designer** - Mobile-first design, touch interactions, and platform patterns
- **conversion-optimizer** - Conversion optimization, copywriting, and buyer journeys

### Implement Agents (Sonnet, Full Access)
Balanced agents for code implementation:

- **api-developer** - API endpoint implementation
- **component-builder** - UI component creation
- **feature-builder** - Full-stack feature implementation (works with feature-scout/feature-planner)
- **test-writer** - Test file generation
- **debugger** - Bug investigation and fixes

## Usage Examples

Claude automatically delegates to agents based on the task. You can also explicitly request an agent.

### Explore Agents

**codebase-explorer** — Use when joining a new project or needing a broad overview:
```
Use the codebase-explorer agent to analyze this project
Explore this codebase and document the architecture
I'm new to this project — give me an overview
```

**dependency-analyzer** — Use when auditing packages or investigating dependency issues:
```
Analyze the dependencies in this project for vulnerabilities
Check for outdated or unused packages
Map out the internal module dependency graph
```

**feature-scout** — Use at the start of a new thread to quickly gather context for a feature:
```
Scout the codebase for context to build a user notifications feature
I need to add export-to-CSV to the reports page — scout the relevant context
Scout context for adding role-based access control across the app
```

**pattern-finder** — Use before writing code to match existing conventions:
```
What component conventions does this project use?
Find the API endpoint patterns so I can match the existing style
How should I write tests in this project?
```

### Plan Agents

**architecture-planner** — Use for major features requiring system design:
```
Design the architecture for adding real-time collaboration with conflict resolution
Plan the system design for a multi-tenant SaaS migration
How should we architect a plugin system for this app?
```

**feature-planner** — Use to break features into phases, tasks, and estimates:
```
Break down the user authentication feature into tasks with estimates
Plan the implementation of a comments system — phases, dependencies, and timeline
We're integrating Stripe payments — plan the implementation phases
```

**refactor-planner** — Use when planning technical debt reduction or modernization:
```
Plan a refactor to migrate from REST to GraphQL
How should we restructure the monolithic service layer?
Plan the migration from JavaScript to TypeScript
```

### Design Agents

**ui-ux-designer** — Use for visual design systems and polished interfaces:
```
Create a design system with color palette, typography, and component tokens
Redesign the dashboard to feel more professional and cohesive
Design the visual identity for the settings pages
```

**mobile-designer** — Use for mobile-first and touch-optimized interfaces:
```
Optimize the checkout flow for mobile devices
Design touch-friendly navigation with proper thumb zones
Make this data table work well on phone screens
```

**conversion-optimizer** — Use to improve sign-up, purchase, and engagement flows:
```
Optimize the landing page for higher conversion
Improve the onboarding flow to reduce drop-off
Rewrite the pricing page copy for better engagement
```

### Implement Agents

**api-developer** — Use for individual API endpoints:
```
Implement POST /api/projects to create a new project
Add PATCH /api/users/:id/profile for updating user profiles
Create GET /api/posts with filtering by tag and status
```

**component-builder** — Use for individual UI components:
```
Build a Modal component with close button and focus trap
Create a UserCard component with avatar and status badge
Build a sortable DataTable with pagination
```

**feature-builder** — Use for full-stack features spanning multiple layers:
```
Build a user notifications feature with bell icon, dropdown, and mark-as-read
Build a webhook receiver for Stripe events that updates order status
Add a dashboard page with analytics charts using the existing analytics API
```

**test-writer** — Use to add test coverage:
```
Write tests for the authentication module
Generate tests for the UserProfile component with all edge cases
Add integration tests for the checkout API endpoints
```

**debugger** — Use to investigate and fix issues:
```
Investigate why the login flow fails intermittently
Debug the memory leak in the WebSocket connection handler
This API endpoint returns 500 for certain inputs — find and fix the cause
```

## Workflows

### Feature Pipeline (scout → plan → build)

For larger features, chain the feature agents:

```
1. Use feature-scout to gather context for adding comments to blog posts
2. Use feature-planner to break down the comments feature into tasks
3. Use feature-builder to implement the comments feature
```

Each step is optional — feature-builder works standalone for simpler features.

### Design Pipeline (analyze → design → optimize)

For UI-heavy work, chain the design agents:

```
1. Use pattern-finder to understand existing UI conventions
2. Use ui-ux-designer to create the visual design
3. Use mobile-designer to optimize for touch devices
4. Use conversion-optimizer to improve conversion metrics
```

### Investigation Pipeline (explore → debug → test)

For troubleshooting:

```
1. Use codebase-explorer to understand the affected area
2. Use debugger to find and fix the root cause
3. Use test-writer to add regression tests
```

## Creating Custom Agents

Agents are Markdown files with YAML frontmatter:

```markdown
---
name: my-agent
description: When to use this agent
tools: Read, Grep, Glob
model: haiku
---

You are a specialist in [domain]. When invoked:
1. Understand the task
2. Execute systematically
3. Return clear results
```

### Model Selection

| Model | Cost | Speed | Best For |
|-------|------|-------|----------|
| haiku | $ | Fast | Exploration, search, simple analysis |
| sonnet | $$ | Medium | Implementation, code generation, reviews |
| opus | $$$ | Slower | Architecture, complex planning, design |

See [Agent Design Best Practices](../../docs/best-practices/agent-design.md) for details.
