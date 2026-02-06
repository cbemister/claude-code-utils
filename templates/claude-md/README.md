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
- React Native
- Electron
- Vue.js / Nuxt
- Svelte / SvelteKit
- Ruby on Rails
- Go applications
- Rust projects

---

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [Claude Code Documentation](https://code.claude.com/docs)
