# Documentation

Comprehensive documentation for Claude Code Shared Resources.

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

Setting up for a team?

1. **[Installation Guide](./guides/installation.md)** - Team setup section
   - Per-project installation
   - Shared resources
   - Version control

2. **[Worktree Workflow](./best-practices/worktree-workflow.md)** - Team usage section
   - Sharing conventions
   - Plan templates
   - Collaboration patterns

---

## Documentation by Topic

### Sub-Agents

**What:** Specialized AI assistants for specific tasks

**Learn:**
- [Getting Started - Understanding Agents](./guides/getting-started.md#sub-agents)
- [Agent Design Best Practices](./best-practices/agent-design.md)
- [Model Selection Guide](./best-practices/model-selection.md)

**Examples:**
- `.claude/agents/explore/` - Exploration agents
- `.claude/agents/plan/` - Planning agents
- `.claude/agents/implement/` - Implementation agents

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

**Templates:**
- `templates/claude-md/minimal.md` - Simple projects
- `templates/claude-md/nextjs-app.md` - Next.js applications
- `templates/claude-md/node-library.md` - npm packages
- `templates/claude-md/api-service.md` - REST APIs
- `templates/claude-md/cli-tool.md` - CLI applications
- `templates/claude-md/python-app.md` - Python projects
- `templates/claude-md/game-browser.md` - Browser games

**Quality Metrics:**
- Completeness (25%) - Has required sections
- Accuracy (25%) - Paths exist, versions match
- Specificity (20%) - Project-specific content
- Code Examples (15%) - Real examples from your code
- Maintenance (15%) - Kept current

---

### Planning System

**What:** Structured feature planning with templates

**Learn:**
- [Getting Started - Workflow Examples](./guides/getting-started.md#common-workflows)
- [Worktree Workflow](./best-practices/worktree-workflow.md)

**Templates:**
- `plans/templates/feature-plan.md`
- `plans/templates/bugfix-plan.md`
- `plans/templates/refactor-plan.md`

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
| Custom agent | [Agent Design](./best-practices/agent-design.md) |
| Custom skill | [Skill Authoring](./best-practices/skill-authoring.md) |
| Parallel dev | [Worktree Workflow](./best-practices/worktree-workflow.md) |

---

## Feedback

Have suggestions for documentation improvements?
- What's unclear?
- What's missing?
- What could be better explained?

Let us know so we can improve!
