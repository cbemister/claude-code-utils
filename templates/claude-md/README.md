# CLAUDE.md Templates

Pre-built CLAUDE.md templates for different project types. Use these as starting points for documenting your codebase for Claude.

## What is CLAUDE.md?

CLAUDE.md is a project-specific documentation file that lives in your repository and tells Claude Code how your project works. It includes:
- Tech stack and dependencies
- Project structure
- Code patterns and conventions
- API design patterns
- Key files and their purposes

Think of it as a README.md specifically for Claude to understand your codebase.

---

## Available Templates

### [nextjs-app.md](./nextjs-app.md) - Next.js Applications
Comprehensive template for Next.js apps with:
- App Router patterns
- API route conventions
- Component patterns
- Database integration (Drizzle/Prisma)
- Authentication patterns
- Styling conventions (CSS Modules/Tailwind)

**Use for:**
- Next.js web applications
- Full-stack React apps
- SaaS products
- Web platforms

**Example projects:**
- E-commerce sites
- Dashboards
- Admin panels
- Content management systems

---

### [node-library.md](./node-library.md) - Node.js Libraries
Template for publishable npm packages with:
- Library API design patterns
- Export structure
- Type definitions
- Testing patterns
- Build configuration
- Publishing workflow

**Use for:**
- npm/yarn packages
- Utility libraries
- SDKs and clients
- Framework plugins

**Example projects:**
- API clients
- Validation libraries
- Build tools
- Testing utilities

---

### [api-service.md](./api-service.md) - API Services
Template for backend REST APIs with:
- Route organization
- Middleware patterns
- Request validation
- Error handling
- Authentication/Authorization
- Database integration

**Use for:**
- REST APIs
- Microservices
- Backend services
- GraphQL APIs

**Example projects:**
- Express/Fastify APIs
- Backend microservices
- Authentication services
- Data processing APIs

---

### [cli-tool.md](./cli-tool.md) - Command Line Tools
Template for CLI applications with:
- Command structure patterns
- Argument parsing
- Interactive prompts
- Help text conventions
- Configuration handling
- Testing CLI applications

**Use for:**
- Command-line utilities
- Developer tools
- Build tools
- Automation scripts

**Example projects:**
- Code generators
- Build/deployment tools
- File processors
- CLI frameworks

---

### [game-browser.md](./game-browser.md) - Browser Games
Template for browser-based games with:
- Game loop architecture
- Scene management
- Entity/sprite patterns
- Asset loading
- Input handling
- State management

**Use for:**
- Canvas games
- Phaser.js games
- WebGL games
- Casual browser games

**Example projects:**
- 2D platformers
- Puzzle games
- Arcade games
- Educational games

---

### [python-app.md](./python-app.md) - Python Applications
Template for Python projects with:
- Project structure patterns
- Virtual environment setup
- Type hints conventions
- Testing patterns (pytest)
- Framework-specific patterns

**Use for:**
- FastAPI services
- Flask applications
- Django projects
- Python scripts

**Example projects:**
- Web APIs
- Data processing apps
- Machine learning services
- Automation tools

---

### [react-native.md](./react-native.md) - React Native + Expo
Template for mobile apps with:
- Expo Router file-based navigation
- React Query for data fetching
- Zustand for state management
- NativeWind utility styling
- EAS build workflows

**Use for:**
- iOS and Android mobile apps
- Cross-platform mobile projects
- Expo-based apps

**Example projects:**
- Consumer mobile apps
- B2B mobile tools
- Companion apps for web platforms

---

### [flutter.md](./flutter.md) - Flutter + Dart
Template for Flutter apps with:
- Riverpod state management
- go_router navigation
- Dio HTTP client
- Freezed data classes
- Feature-sliced project structure

**Use for:**
- Cross-platform mobile apps
- iOS, Android, and web from one codebase
- Material 3 design apps

**Example projects:**
- Consumer mobile apps
- Enterprise mobile clients
- Cross-platform tools

---

### [django.md](./django.md) - Django + DRF + PostgreSQL
Template for Django projects with:
- Django REST Framework ViewSets
- Celery background tasks
- pytest-django testing patterns
- Environment management with django-environ

**Use for:**
- Django web applications
- REST APIs with Django
- Python backends with admin panels

**Example projects:**
- Content platforms
- SaaS backends
- Internal tools with admin UIs

---

### [nestjs.md](./nestjs.md) - NestJS + TypeScript + TypeORM
Template for NestJS projects with:
- Module-based feature architecture
- TypeORM entities and repositories
- Swagger / OpenAPI documentation
- class-validator DTOs
- JWT authentication pattern

**Use for:**
- TypeScript backend APIs
- Node.js microservices
- Enterprise Node.js applications

**Example projects:**
- REST APIs
- GraphQL services
- Microservice backends

---

### [rails.md](./rails.md) - Rails 7 + Hotwire + PostgreSQL
Template for Rails projects with:
- Hotwire (Turbo + Stimulus) patterns
- RSpec + FactoryBot testing
- Sidekiq background jobs
- Standard Rails conventions

**Use for:**
- Rails web applications
- Full-stack Ruby projects
- Rapid prototyping with Rails

**Example projects:**
- SaaS products
- Marketplaces
- Content platforms

---

### [go-api.md](./go-api.md) - Go + Chi/Gin + PostgreSQL
Template for Go REST APIs with:
- Standard Go project layout (cmd/, internal/, pkg/)
- Chi or Gin router patterns with middleware
- sqlx / pgx database access with repository pattern
- Air hot reload setup
- testify-based unit and integration tests

**Use for:**
- Go HTTP services and REST APIs
- High-performance microservices
- Go backends replacing Node/Python services

**Example projects:**
- Auth services
- CRUD APIs
- Data ingestion pipelines

---

### [rust-cli.md](./rust-cli.md) - Rust + clap + tokio
Template for Rust CLI tools with:
- Single-crate and multi-crate workspace layouts
- clap derive API for subcommands and typed args
- tokio async runtime with spawn_blocking for CPU work
- thiserror / anyhow error handling strategy
- assert_cmd CLI integration tests

**Use for:**
- Command-line tools and developer utilities
- Multi-crate Rust workspaces
- High-performance or systems CLI apps

**Example projects:**
- File processors and converters
- Developer tooling
- Build and deployment tools

---

### [svelte.md](./svelte.md) - SvelteKit + TypeScript
Template for SvelteKit applications with:
- File-based routing (+page.svelte / +page.server.ts)
- Superforms + Zod for type-safe form handling
- Drizzle ORM with PostgreSQL
- Svelte stores and reactive state
- Server-only code in $lib/server/

**Use for:**
- SvelteKit full-stack web apps
- Content sites with dynamic data
- SaaS products preferring Svelte

**Example projects:**
- Dashboards and admin panels
- E-commerce storefronts
- Content management tools

---

### [vue.md](./vue.md) - Nuxt 3 + Vue 3 + TypeScript
Template for Nuxt 3 applications with:
- Composition API with `<script setup>` throughout
- Pinia stores with auto-imports
- VueUse composables
- Nuxt server API routes (Nitro engine)
- Route middleware for auth guarding

**Use for:**
- Nuxt 3 full-stack applications
- Vue 3 SSR / SSG sites
- Vue-based SaaS products

**Example projects:**
- Marketing and content platforms
- Dashboards
- E-commerce sites

---

### [astro.md](./astro.md) - Astro + TypeScript + Tailwind
Template for Astro sites with:
- Content Collections with Zod schemas
- Island architecture and client: hydration directives
- MDX support and View Transitions API
- Dynamic routes with getStaticPaths
- Server endpoints for hybrid API routes

**Use for:**
- Static or hybrid Astro sites
- Blogs and documentation sites
- Performance-critical marketing sites

**Example projects:**
- Developer blogs
- Documentation sites
- Portfolio and landing pages

---

### [minimal.md](./minimal.md) - Simple Projects
Lightweight template for:
- Simple projects
- Prototypes
- Scripts
- Small utilities

**Use for:**
- Quick experiments
- One-off scripts
- Learning projects
- Minimal applications

---

## Enterprise Templates

For enterprise-grade projects that need a full Claude Code configuration layer (agent teams, rules, hooks, plugin marketplace, MCP, context management), use the enterprise templates instead of a standalone CLAUDE.md.

### Enterprise (`templates/enhance-app/`)
Complete `.claude/` configuration for any project (new or existing). Scans what exists, installs what's missing. Includes:
- 8 specialized agents (linked from shared source — not duplicated per project)
- `.claude/rules/` knowledge base (auto-populated from codebase analysis)
- Hooks: secret scanning, auto-format, TypeScript check, bash protection
- Plugin marketplace catalog (`marketplace.json`)
- MCP server configuration
- Plan templates (linked from shared source)

**Use:** Run `/enhance-app` in your project directory.

---

## How to Use

### 1. Choose a Template

Pick the template that matches your project type.

### 2. Copy to Your Project

```bash
# From your project root
cp path/to/template/nextjs-app.md CLAUDE.md
```

Or if you're using the central installation:
```bash
cp ~/.claude/templates/claude-md/nextjs-app.md CLAUDE.md
```

### 3. Customize the Template

Edit CLAUDE.md and replace placeholders:
- `[Project Name]` → Your project name
- `[Description]` → Actual description
- `[Technology]` → Technologies you use
- Remove sections you don't need
- Add project-specific patterns

### 4. Keep It Updated

As your project evolves:
- Add new patterns
- Document important decisions
- Update tech stack
- Add new conventions

---

## Creating Custom Templates

### Start from Existing Template

1. Copy a template that's closest to your needs
2. Modify sections to match your stack
3. Add project-specific patterns
4. Save as new template

### Template Structure

Good templates include:

**Overview Section:**
- What the project does
- Tech stack
- Key dependencies

**Project Structure:**
- Directory layout
- Purpose of each directory
- File naming conventions

**Patterns Section:**
- Code examples
- Common patterns
- Anti-patterns to avoid

**Key Files:**
- Important files and their purpose
- Entry points
- Configuration files

**Development:**
- Setup instructions
- Commands
- Environment variables

---

## Best Practices

### Do:
- ✅ Include actual code examples
- ✅ Document project-specific patterns
- ✅ Keep it updated
- ✅ Reference key files
- ✅ Explain "why" not just "what"

### Don't:
- ❌ Copy-paste generic documentation
- ❌ Include too much boilerplate
- ❌ Document obvious things
- ❌ Let it get stale
- ❌ Make it too long (aim for 200-400 lines)

### Tips:
- **Be specific:** "Use Drizzle ORM with PostgreSQL" not "Use a database"
- **Show patterns:** Include code examples of common patterns
- **Link files:** Reference actual file paths in your project
- **Update regularly:** Treat it like code, not static docs
- **Think onboarding:** What would help a new developer understand the project?

---

## Quality Standards

For comprehensive guidance on writing effective CLAUDE.md files, see:
**[CLAUDE.md Authoring Best Practices](../docs/best-practices/claude-md-authoring.md)**

### Key Quality Metrics

| Category | Weight | Criteria |
|----------|--------|----------|
| **Completeness** | 25% | Has all required sections (Overview, Tech Stack, Structure, Commands) |
| **Accuracy** | 25% | Information matches actual project state (paths exist, versions correct) |
| **Specificity** | 20% | Contains project-specific content, not generic boilerplate |
| **Code Examples** | 15% | Includes actual examples from your codebase |
| **Maintenance** | 15% | Kept current as project evolves |

### Quality Checklist

Before committing your CLAUDE.md:
- [ ] All file paths referenced actually exist
- [ ] Tech stack versions match package.json/requirements.txt
- [ ] Commands work as documented
- [ ] Has at least 2-3 real code examples from your project
- [ ] Contains project-specific patterns (not just framework defaults)
- [ ] Length is 200-400 lines (not too short, not too long)
- [ ] No obviously stale or outdated information

---

## Examples

### Minimal Customization
```markdown
# My Todo App - Project Documentation

## Overview
A simple todo list application built with Next.js and PostgreSQL.

## Tech Stack
- Next.js 14 with App Router
- TypeScript
- Drizzle ORM with PostgreSQL
- Tailwind CSS
...
```

### Full Customization
Add project-specific sections:
```markdown
## Our Specific Patterns

### Data Fetching
We always use Server Components for initial data:
```typescript
// app/todos/page.tsx
export default async function TodosPage() {
  const todos = await db.query.todos.findMany();
  return <TodoList todos={todos} />;
}
```

### Mutations
All mutations use Server Actions:
```typescript
'use server';
export async function createTodo(formData: FormData) {
  // Implementation
}
```
```

---

## Template Maintenance

### Updating Templates
When you find a great pattern:
1. Add it to your project's CLAUDE.md
2. If it's generally useful, add to template
3. Share with team

### Versioning
Templates evolve with:
- New framework versions
- Better patterns discovered
- Team preferences

---

## FAQ

**Q: Do I need CLAUDE.md?**
A: Not required, but highly recommended for complex projects. It helps Claude understand your codebase faster and produce better code.

**Q: How long should it be?**
A: 200-400 lines is ideal. Long enough to be useful, short enough to stay updated.

**Q: Should I commit it to git?**
A: Yes! It's project documentation that benefits the whole team.

**Q: Can I have multiple CLAUDE.md files?**
A: You can only have one `CLAUDE.md` in the root. For monorepos, put package-specific docs in each package.

**Q: What if my stack isn't covered?**
A: Start with `minimal.md` and customize, or use the closest template and adapt it.

---

## Contributing

Have a template for a popular stack? Contributions welcome:
1. Create template following the pattern from existing templates
2. Include comprehensive code examples
3. Reference docs/best-practices/claude-md-authoring.md for quality standards
4. Test with an actual project of that type
5. Submit PR

Popular stacks we'd love templates for:
- Electron
- Remix
- Laravel / PHP
- Android (Kotlin + Jetpack Compose)

---

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [Claude Code Documentation](https://code.claude.com/docs)
