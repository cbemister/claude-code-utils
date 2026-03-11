# Documentation

Comprehensive documentation for the Claude Code App Launchpad.

## Quick Links

### Getting Started
- [Installation Guide](./guides/installation.md) - How to install and configure
- [Getting Started Guide](./guides/getting-started.md) - Your first steps with the resources

### Best Practices
- [Model Selection](./best-practices/model-selection.md) - Choosing Haiku, Sonnet, or Opus
- [Agent Design](./best-practices/agent-design.md) - Creating effective sub-agents
- [Skill Authoring](./best-practices/skill-authoring.md) - Writing reusable skills
- [CLAUDE.md Authoring](./best-practices/claude-md-authoring.md) - Writing effective project documentation
- [Worktree Workflow](./best-practices/worktree-workflow.md) - Mastering git worktrees

---

## Documentation Structure

```
docs/
├── README.md                          # This file
├── guides/                            # Step-by-step guides
│   ├── installation.md                # Installation instructions
│   └── getting-started.md             # Quick start guide
└── best-practices/                    # In-depth best practices
    ├── model-selection.md             # Model selection strategy
    ├── agent-design.md                # Agent design patterns
    ├── skill-authoring.md             # Skill authoring guide
    ├── claude-md-authoring.md         # CLAUDE.md best practices
    └── worktree-workflow.md           # Git worktree workflow
```

---

## For New Users

Start here:

1. **[Installation Guide](./guides/installation.md)**
   - Choose installation method
   - Install resources
   - Verify setup

2. **[Getting Started Guide](./guides/getting-started.md)**
   - Understand what's available
   - Try your first agent
   - Create a plan
   - Use worktrees

3. **Pick a Best Practice Guide**
   - [Model Selection](./best-practices/model-selection.md) - Optimize costs
   - [Worktree Workflow](./best-practices/worktree-workflow.md) - Parallel development

---

## For Customization

Want to create your own resources?

1. **[Agent Design](./best-practices/agent-design.md)**
   - Understand agent architecture
   - Choose appropriate model
   - Define clear workflow
   - Test thoroughly

2. **[Skill Authoring](./best-practices/skill-authoring.md)**
   - Write step-by-step instructions
   - Handle errors gracefully
   - Provide clear output
   - Document thoroughly

---

## For Teams

Setting up agent teams for a project?

1. **[Agent Team Selection](../templates/prep-claude/teams/README.md)**
   - Choose a team preset (Enterprise, SaaS, Internal Tool, Game, Marketing)
   - Compare agent compositions
   - Use `/team-battle` to compare teams head-to-head

2. **[Prep Claude](../templates/prep-claude/)** - Full project setup
   - Run `/prep-claude` to install agents, rules, hooks, plans
   - Customize team composition in `teams/teams.json`

3. **[Worktree Workflow](./best-practices/worktree-workflow.md)** - Parallel development
   - Feature isolation with worktrees
   - Plan templates for stage-based builds
   - Collaboration patterns

---

## Documentation by Topic

### Sub-Agents

**What:** Specialized AI assistants for specific tasks

**Learn:**
- [Getting Started - Understanding Agents](./guides/getting-started.md#sub-agents)
- [Agent Design Best Practices](./best-practices/agent-design.md)
- [Model Selection Guide](./best-practices/model-selection.md)

**Base Library:**
- `.claude/agents/explore/` - Exploration agents
- `.claude/agents/plan/` - Planning agents
- `.claude/agents/implement/` - Implementation agents

---

### Agent Teams

**What:** Pre-configured teams of specialized agents optimized for different project types. Installed via `/prep-claude`.

**Learn:**
- [Team Comparison & Selection](../templates/prep-claude/teams/README.md)
- [Agent Pool (all 11 agents)](../templates/prep-claude/.claude/agents/README.md)

**Team Presets:**

| Team | Agents | Best For |
|------|--------|----------|
| Enterprise Engineering | 8 (no design) | APIs, data pipelines, complex backends |
| SaaS Product | 9 (UI/UX + Conversion) | SaaS apps, dashboards, subscription products |
| Internal Tool | 9 (UI/UX practical) | Admin panels, developer tools |
| Game / Interactive | 7 (UI/UX + Mobile) | Games, creative tools, canvas apps |
| Marketing Site | 7 (all 3 designers) | Landing pages, marketing sites |

**Design Agents (Opus):**
- `ui-ux-designer` — Visual design systems, brand-driven interfaces (14 skills)
- `mobile-designer` — Mobile-first UX, thumb zones, platform patterns (5 skills)
- `conversion-optimizer` — Conversion psychology, copywriting, CTAs (5 skills)

**Team Battle:** `/team-battle` runs two teams on the same task in separate worktrees for side-by-side comparison.

---

### Skills

**What:** Reusable workflow automations invoked with `/skill-name`

**Learn:**
- [Getting Started - Understanding Skills](./guides/getting-started.md#skills)
- [Skill Authoring Best Practices](./best-practices/skill-authoring.md)

**Examples:**
- `.claude/skills/worktree-*.md` - Worktree workflow skills
- `.claude/skills/create-plan.md` - Plan creation
- `.claude/skills/plan-status.md` - Plan tracking

---

### CLAUDE.md Documentation

**What:** Project-specific documentation that helps Claude understand your codebase

**Learn:**
- [CLAUDE.md Authoring Best Practices](./best-practices/claude-md-authoring.md)
- [Templates](../templates/claude-md/README.md)

**Templates (17 tech stacks):**
- `templates/claude-md/nextjs-app.md` - Next.js / T3 / Electron
- `templates/claude-md/api-service.md` - Express APIs
- `templates/claude-md/python-app.md` - FastAPI / Python
- `templates/claude-md/cli-tool.md` - Node.js CLI
- `templates/claude-md/node-library.md` - npm packages
- `templates/claude-md/game-browser.md` - Phaser / browser games
- `templates/claude-md/minimal.md` - Simple projects
- `templates/claude-md/react-native.md` - React Native + Expo
- `templates/claude-md/flutter.md` - Flutter + Dart
- `templates/claude-md/django.md` - Django + PostgreSQL
- `templates/claude-md/nestjs.md` - NestJS + TypeORM
- `templates/claude-md/rails.md` - Rails 7 + Ruby
- `templates/claude-md/go-api.md` - Go + Chi/Gin
- `templates/claude-md/rust-cli.md` - Rust + clap
- `templates/claude-md/svelte.md` - SvelteKit
- `templates/claude-md/vue.md` - Nuxt 3 + Vue 3
- `templates/claude-md/astro.md` - Astro + Tailwind

**Quality Metrics:**
- Completeness (25%) - Has required sections
- Accuracy (25%) - Paths exist, versions match
- Specificity (20%) - Project-specific content
- Code Examples (15%) - Real examples from your code
- Maintenance (15%) - Kept current

---

### Planning System

**What:** Staged build planning for launching professional apps

**Core workflow:**
1. `/launch-app` — Go from idea to fully planned project with stage plans and agent assignments
2. `/plan-next-stage` — Refresh a stage plan to account for codebase changes from prior stages

**Learn:**
- [Getting Started - Workflow Examples](./guides/getting-started.md#common-workflows)
- [Worktree Workflow](./best-practices/worktree-workflow.md)

**Plan Templates:**
- `plans/templates/master-plan-readme.md` - Master plan orchestrator with dependency graphs and parallelization maps
- `plans/templates/stage-plan.md` - Build stage with agent teams, parallelization, and tiered verification
- `plans/templates/feature-plan.md` - New feature development
- `plans/templates/bugfix-plan.md` - Bug investigation and fix
- `plans/templates/context-handoff.md` - Cross-session continuity

**Stage Libraries** (reference material for the project-planner agent):
- `templates/stage-libraries/web-fullstack.md` - Next.js, SvelteKit, Nuxt
- `templates/stage-libraries/api-backend.md` - Express, NestJS, FastAPI, Rails, Go
- `templates/stage-libraries/mobile-app.md` - React Native, Flutter
- `templates/stage-libraries/cli-tool.md` - Node, Rust, Go CLIs
- `templates/stage-libraries/desktop-app.md` - Electron
- `templates/stage-libraries/marketing-site.md` - Astro, static sites
- `templates/stage-libraries/game.md` - Phaser, browser games

---

### Git Worktrees

**What:** Parallel development with multiple working directories

**Learn:**
- [Worktree Workflow Guide](./best-practices/worktree-workflow.md)
- [Getting Started - Workflow 1](./guides/getting-started.md#workflow-1-new-feature-development)

**Skills:**
- `/worktree-create` - Create worktree + branch + plan
- `/worktree-sync` - Sync with main branch
- `/worktree-cleanup` - Remove completed worktrees

---

### Model Selection

**What:** Choosing Haiku, Sonnet, or Opus for tasks

**Learn:**
- [Model Selection Guide](./best-practices/model-selection.md)
- [Getting Started - Model Strategy](./guides/getting-started.md#model-selection-strategy)

**Quick Reference:**
- Haiku: Fast, cheap exploration
- Sonnet: Balanced implementation
- Opus: Complex planning and design

---

## Common Questions

### How do I install?

See [Installation Guide](./guides/installation.md)

**Quick answer:**
```bash
# Per-project
git clone <repo-url> .claude

# Central (all projects)
git clone <repo-url> ~/.claude
```

---

### How do agents work?

See [Getting Started - Sub-Agents](./guides/getting-started.md#sub-agents)

**Quick answer:**
- Agents are automatically invoked when tasks match their description
- Or explicitly: "Use the api-developer agent to create an endpoint"
- They return results to main Claude
- See [Agent Design](./best-practices/agent-design.md) for creating custom agents

---

### How do I invoke skills?

See [Getting Started - Skills](./guides/getting-started.md#skills)

**Quick answer:**
```bash
/skill-name argument
# Example:
/worktree-create feature-name
/plan-status
```

---

### Which model should I use?

See [Model Selection Guide](./best-practices/model-selection.md)

**Quick answer:**
- Exploration → Haiku
- Implementation → Sonnet
- Architecture/Design → Opus
- Target: 50-70% Haiku, 25-40% Sonnet, 5-10% Opus

---

### How do worktrees work?

See [Worktree Workflow Guide](./best-practices/worktree-workflow.md)

**Quick answer:**
```bash
/worktree-create feature-name
cd worktrees/feature-name
# Work on feature
/worktree-sync  # Sync with main
# Create PR when done
/worktree-cleanup feature-name  # After merge
```

---

### How do I write a good CLAUDE.md?

See [CLAUDE.md Authoring Best Practices](./best-practices/claude-md-authoring.md)

**Quick answer:**
- 200-400 lines, not more
- Include actual code examples from YOUR project
- Document patterns, not obvious things
- Keep it updated when project changes
- Use a template as starting point:
  - Next.js app → `templates/claude-md/nextjs-app.md`
  - API service → `templates/claude-md/api-service.md`
  - CLI tool → `templates/claude-md/cli-tool.md`
  - Python app → `templates/claude-md/python-app.md`
  - Game → `templates/claude-md/game-browser.md`
  - Simple project → `templates/claude-md/minimal.md`

---

### How do I create a custom agent?

See [Agent Design Best Practices](./best-practices/agent-design.md)

**Quick answer:**
1. Copy template: `templates/agents/agent-template.md`
2. Customize frontmatter (name, description, model, tools)
3. Define workflow and output format
4. Test thoroughly

---

### How do I create a custom skill?

See [Skill Authoring Best Practices](./best-practices/skill-authoring.md)

**Quick answer:**
1. Copy template: `templates/skills/skill-template.md`
2. Write step-by-step instructions
3. Add examples and troubleshooting
4. Test with various inputs

---

### How do I track feature progress?

See [Getting Started - Common Workflows](./guides/getting-started.md#common-workflows)

**Quick answer:**
```bash
/create-plan feature-name
# Edit plan, fill in tasks
/plan-status feature-name
# Update as you work
```

---

## Contributing to Documentation

Found an error or want to improve the docs?

1. Edit the relevant `.md` file
2. Keep the same structure and tone
3. Test any code examples
4. Submit improvements

---

## Documentation Maintenance

These docs cover:
- ✅ Installation (per-project, central, selective)
- ✅ Getting started workflows
- ✅ Model selection strategy
- ✅ Agent design patterns
- ✅ Skill authoring guide
- ✅ Worktree workflow
- ✅ Troubleshooting
- ✅ Examples throughout

**Keep Updated:**
- When adding new agents → Update [Getting Started](./guides/getting-started.md#sub-agents)
- When adding new skills → Update [Getting Started](./guides/getting-started.md#skills)
- When changing templates → Update relevant guides
- When discovering best practices → Update best practices docs

---

## Quick Reference

| Need | Document |
|------|----------|
| Install | [Installation Guide](./guides/installation.md) |
| First steps | [Getting Started](./guides/getting-started.md) |
| Save money | [Model Selection](./best-practices/model-selection.md) |
| Agent teams | [Team Selection](../templates/prep-claude/teams/README.md) |
| Custom agent | [Agent Design](./best-practices/agent-design.md) |
| Custom skill | [Skill Authoring](./best-practices/skill-authoring.md) |
| Parallel dev | [Worktree Workflow](./best-practices/worktree-workflow.md) |
| Stage plans | [Plan Templates](../plans/templates/README.md) |

---

## Feedback

Have suggestions for documentation improvements?
- What's unclear?
- What's missing?
- What could be better explained?

Let us know so we can improve!
