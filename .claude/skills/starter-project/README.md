# Starter Project Generator

A Claude Code skill that generates complete starter projects pre-configured with agents and skills.

## Overview

The `/starter-project` skill scaffolds production-ready starter projects that demonstrate how to use Claude Code's shared resource agents and skills. Each generated project includes:

- **Pre-configured agents** - Relevant sub-agents for the project type
- **Workflow skills** - Development, testing, git, and planning skills
- **CLAUDE.md** - Project-specific conventions and patterns
- **Initial plan** - Getting-started guide with suggested first features
- **Working foundation** - Minimal but functional code that compiles and runs

## Available Templates

| Template | Stack | Best For |
|----------|-------|----------|
| **SaaS Web App** | Next.js, Auth, Dashboard, Drizzle ORM | Full-stack applications demonstrating all agents |
| **API Service** | Node.js, Express, TypeScript, Testing | Backend services and REST APIs |
| **Component Library** | React, Storybook, CSS Modules | UI component development and design systems |
| **CLI Tool** | Node.js, Commander.js, TypeScript | Command-line applications |
| **E-Commerce** | Next.js, Stripe, Products, Cart | Online stores with payments |
| **Browser Game** | Phaser.js, TypeScript, Vite | Interactive games and visualizations |

## Usage

### Interactive Mode

```bash
/starter-project
```

Claude will prompt you to:
1. Select a template category
2. Enter a project name
3. Optionally configure features

### Direct Mode

```bash
/starter-project saas my-awesome-app
/starter-project api my-api-service
/starter-project components design-system
```

## Generated Project Structure

Projects are created as **sibling folders** to keep them separate from the shared resource repo:

```
parent-directory/
├── claude-code-shared/       # This repo (source of agents/skills)
└── my-new-project/           # Your generated starter
    ├── CLAUDE.md             # Project-specific instructions
    ├── .claude/
    │   ├── agents/           # Copied agents
    │   └── skills/           # Copied skills
    ├── plans/
    │   └── active/
    │       └── getting-started/
    │           └── plan.md   # Initial development plan
    ├── [project files...]
    └── README.md
```

## How It Works

### Dynamic Generation

Instead of static template files, this skill uses **dynamic generation**:

1. Reads template specifications from `templates/README.md`
2. Generates files using Claude's knowledge of best practices
3. Replaces placeholders (`{{PROJECT_NAME}}`, etc.)
4. Copies relevant agents and skills
5. Initializes git with clean commit
6. Creates getting-started plan

This approach:
- ✅ Stays current with framework updates
- ✅ Reduces maintenance burden
- ✅ Leverages Claude's full knowledge
- ✅ Adapts to user preferences

### Template Specifications

Each template has:
- `manifest.json` - Metadata and configuration
- Specifications in `templates/README.md` - File structures and content guidelines
- Getting-started plans - Suggested first features mapped to specific agents

## Example: Creating a SaaS Starter

```bash
User: /starter-project saas task-manager

Claude: Creating SaaS Web App starter: task-manager...

✓ Created project directory
✓ Copied all agents (explore, plan, implement, design)
✓ Copied development workflow skills
✓ Generated project files from template
✓ Initialized git repository
✓ Created initial plan at plans/active/getting-started/

================================================================
✅ Successfully created SaaS Web App: task-manager
================================================================

📁 Location: ../task-manager

Next steps:

  1. cd ../task-manager
  2. npm install
  3. cp .env.example .env (and configure)
  4. npm run db:push
  5. npm run dev

📋 Your getting-started plan:
   plans/active/getting-started/plan.md

🎯 Suggested first tasks:
   • Use 'architecture-planner' to design your data model
   • Use 'api-developer' to build your first API endpoint
   • Use 'ui-ux-designer' to design your dashboard

💡 Tips:
   • Run '/plan-status' to track your progress
   • Use '/worktree-create' for parallel feature development
   • Use '/ship' at the end of each session
```

## Generated Projects Include

### All Projects

- **CLAUDE.md** - Framework and project-specific conventions
- **Agents** - Relevant sub-agents for the project type
- **Skills** - ship, verify-work, organize-commits, track-progress, generate-tests, performance-check, worktree-*, create-plan, plan-status
- **Initial Plan** - Getting-started guide with agent-mapped features
- **Git Repository** - Clean initial commit
- **README** - Setup and development instructions

### SaaS Web App Specifics

- Next.js 14 App Router
- NextAuth authentication
- Drizzle ORM with PostgreSQL
- Tailwind CSS
- Basic dashboard structure
- User management
- Example API routes

### API Service Specifics

- Express server
- Health check endpoint
- Auth middleware structure
- Database connection setup
- Vitest testing configuration
- Example tests

### Component Library Specifics

- Storybook configuration
- Example Button component
- CSS Modules setup
- Design token structure
- Component testing setup

### CLI Tool Specifics

- Commander.js setup
- Example `init` command
- Config management
- Interactive prompts
- Testing setup

### E-Commerce Specifics

- Product catalog structure
- Cart functionality skeleton
- Stripe integration setup
- Checkout flow structure

### Browser Game Specifics

- Phaser.js game engine
- Scene management
- Player entity example
- Asset loading setup

## Development Workflow

After generating a starter:

1. **Explore the structure**
   ```bash
   cd ../your-project
   cat CLAUDE.md  # Read project conventions
   cat plans/active/getting-started/plan.md  # Read initial plan
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development**
   ```bash
   npm run dev
   ```

4. **Build your first feature**
   ```bash
   /create-plan "First Feature"
   # Use suggested agents from getting-started plan
   ```

5. **Ship your work**
   ```bash
   /ship
   ```

## Customization

Generated projects are **foundations, not constraints**:

- Modify any file
- Add/remove dependencies
- Change tech stack components
- Customize CLAUDE.md
- Add/remove agents and skills

The starter gives you:
- Working baseline
- Best practices
- Agent integration examples
- Development workflow

You build from there.

## Tips

### Choosing the Right Template

- **SaaS Web App** - Most comprehensive, demonstrates all features
- **API Service** - Backend-focused, great for microservices
- **Component Library** - Design system work, reusable components
- **CLI Tool** - Developer tools, automation scripts
- **E-Commerce** - Product-based businesses
- **Browser Game** - Interactive experiences, visualizations

### After Generation

1. **Review the plan** - Understand suggested first steps
2. **Explore agents** - Check [`.claude/agents/README.md`](../../agents/README.md)
3. **Try a feature** - Follow getting-started suggestions
4. **Use worktrees** - Parallel development from day one
5. **Ship frequently** - Use `/ship` to maintain quality

### Learning Path

1. Generate a starter
2. Build suggested first feature using agents
3. Observe how agents work together
4. Apply patterns to your own features
5. Customize and extend

## Troubleshooting

### Directory Already Exists

```
❌ Directory already exists: ../my-project
```

**Solution:** Choose a different name or remove the existing directory

### Missing Template Files

```
❌ Template not found for category: saas
```

**Solution:** Ensure you're running from the claude-code-shared repository or that the skill is properly installed with template specifications

### Generation Errors

If file generation fails:
1. Check you have write permissions to parent directory
2. Ensure git is installed
3. Try a different project name (avoid special characters)

## Development

### Adding a New Template

1. Create directory: `templates/new-template/`
2. Add `manifest.json`:
   ```json
   {
     "name": "Template Name",
     "description": "Template description",
     "stack": ["Tech1", "Tech2"],
     "agents": ["relevant", "agents"],
     "features": {
       "included": ["feature1"],
       "optional": []
     },
     "postSetup": ["npm install"],
     "suggestedTasks": ["Task 1", "Task 2"]
   }
   ```
3. Add specification to `templates/README.md`
4. Update `SKILL.md` with new category
5. Test generation

### Contributing

See [Skill Authoring Best Practices](../../../docs/best-practices/skill-authoring.md) for guidelines on improving this skill.

## Related Documentation

- [Agents README](../../agents/README.md) - Understanding sub-agents
- [Skills README](../README.md) - All available skills
- [Getting Started Guide](../../../docs/guides/getting-started.md) - Quick start
- [Worktree Workflow](../../../docs/best-practices/worktree-workflow.md) - Parallel development

## License

Part of Claude Code Shared Resources. See repository license.
