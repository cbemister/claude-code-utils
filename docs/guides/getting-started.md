# Getting Started

Welcome to the Claude Code Shared Resources! This guide will help you get up and running quickly.

## What is This?

A collection of shareable resources for Claude Code including:
- **Sub-agents** - Specialized AI assistants for specific tasks
- **Skills** - Reusable workflow automations
- **Plan templates** - Structured feature planning
- **CLAUDE.md templates** - Project documentation templates
- **Best practices** - Guides for effective development

---

## Quick Start (5 Minutes)

### 1. Choose Installation Method

**Option A: Per-Project** (Recommended for teams)
```bash
cd your-project
git clone https://github.com/username/claude-code-shared .claude
```

**Option B: Central** (Recommended for personal use)
```bash
git clone https://github.com/username/claude-code-shared ~/.claude
```

---

### 2. Try Your First Agent

```bash
# Open Claude Code in your project
claude

# Ask Claude to explore the codebase
> Explore the codebase structure and find all API endpoints
```

Claude will automatically delegate to the **codebase-explorer** agent (Haiku, fast, cheap).

---

### 3. Create Your First Plan

```bash
# Create a plan for a new feature
/create-plan user-authentication

# Edit the plan
# Fill in:
# - Title
# - Success criteria
# - Tasks for each phase

# Check status
/plan-status user-authentication
```

---

### 4. Create a Worktree

```bash
# Create worktree + branch + plan (if not exists)
/worktree-create user-authentication

# Navigate to worktree
cd worktrees/user-authentication

# Start working
# ... code ...

# Sync with main when needed
/worktree-sync
```

---

### 5. Use a Skill

```bash
# Organize your commits
/organize-commits

# Check plan status
/plan-status

# Create a PR
/commit-push-pr
```

---

## Understanding the Resources

### Sub-Agents

Located in `.claude/agents/`, organized by purpose:

**Explore Agents (Haiku - Fast & Cheap):**
- `codebase-explorer` - Explore and analyze codebase structure
- `dependency-analyzer` - Analyze dependency tree
- `pattern-finder` - Find code patterns and conventions

**Plan Agents (Opus - Complex Reasoning):**
- `architecture-planner` - Design system architecture
- `feature-planner` - Break down features into tasks
- `refactor-planner` - Plan refactoring strategy
- `ui-ux-designer` - Design unique, polished interfaces

**Implement Agents (Sonnet - Balanced):**
- `api-developer` - Implement REST API endpoints
- `component-builder` - Build UI components
- `test-writer` - Write comprehensive tests
- `debugger` - Investigate and fix bugs

**Usage:**
Agents are invoked automatically when tasks match their description. You can also explicitly request them:
```
> Use the api-developer agent to create a POST /users endpoint
```

---

### Skills

Located in `.claude/skills/`, invoke with `/skill-name`:

**Git Worktree Workflow:**
- `/worktree-create` - Create worktree + branch + plan
- `/worktree-sync` - Sync worktree with main branch
- `/worktree-cleanup` - Remove completed worktrees

**Plan Management:**
- `/create-plan` - Initialize feature plan
- `/plan-status` - Show plan progress

**Existing Skills (from agile-toolkit):**
- `/organize-commits` - Organize staged changes into logical commits
- `/ship` - Complete end-of-session workflow
- `/track-progress` - Track development progress

**Usage:**
```bash
/worktree-create new-feature
/plan-status
/organize-commits
```

---

### Plan Templates

Located in `plans/templates/`:
- `feature-plan.md` - Standard feature development
- `bugfix-plan.md` - Bug investigation and resolution
- `refactor-plan.md` - Code refactoring
- `subplan-template.md` - Phase sub-plans

**Usage:**
```bash
/create-plan user-auth
# or
/create-plan login-fix --template=bugfix
```

---

### CLAUDE.md Templates

Located in `templates/claude-md/`:
- `nextjs-app.md` - Next.js applications
- `node-library.md` - npm packages
- `minimal.md` - Simple projects

**Usage:**
```bash
# Copy template to your project
cp templates/claude-md/nextjs-app.md CLAUDE.md

# Customize for your project
# Edit CLAUDE.md and replace placeholders
```

---

## Common Workflows

### Workflow 1: New Feature Development

```bash
# 1. Create plan and worktree
/create-plan user-authentication
/worktree-create user-authentication

# 2. Navigate and start work
cd worktrees/user-authentication
# ... code ...

# 3. Track progress
/plan-status user-authentication

# 4. Sync periodically
/worktree-sync

# 5. Create PR when done
git push -u origin feature/user-authentication
gh pr create

# 6. Clean up after merge
cd ~/project
/worktree-cleanup user-authentication
```

---

### Workflow 2: Bug Fix

```bash
# 1. Create bug fix plan
/create-plan login-failure --template=bugfix

# 2. Create worktree
/worktree-create login-failure

# 3. Debug with agent
cd worktrees/login-failure
> Use the debugger agent to investigate the login failure

# 4. Fix and test
# ... fix code ...
npm test

# 5. Create PR
/commit-push-pr

# 6. Clean up
cd ~/project
/worktree-cleanup login-failure
```

---

### Workflow 3: Code Exploration

```bash
# Explore patterns
> Find all API endpoints in the codebase

# Analyze dependencies
> Analyze the dependency tree and find unused dependencies

# Find patterns
> What patterns are used for error handling?

# These automatically use fast Haiku agents
```

---

### Workflow 4: Architecture Design

```bash
# Plan complex features
> Design the architecture for a real-time notification system

# This uses Opus agent for complex reasoning
# Returns detailed architecture recommendation

# Create plan from recommendation
/create-plan notification-system
# Paste architecture details into plan

# Create worktree and start
/worktree-create notification-system
```

---

### Workflow 5: UI Design

```bash
# Design interface
> Design the UI for the dashboard with a playful, modern aesthetic

# UI/UX designer agent (Opus) will:
# 1. Ask about brand personality
# 2. Present 2-3 visual directions
# 3. Provide complete design system

# Implement the design
cd worktrees/dashboard-redesign
# ... implement CSS ...
```

---

## Model Selection Strategy

Choose the right model for cost/quality balance:

**Haiku ($0.25/$1.25 per M tokens) - Fast & Cheap:**
- File searching
- Code exploration
- Pattern finding
- High-volume tasks

**Sonnet ($3/$15 per M tokens) - Balanced:**
- Implementation
- Code reviews
- Bug fixing
- Most development work

**Opus ($15/$75 per M tokens) - Maximum Quality:**
- Architecture design
- Complex planning
- UI/UX design
- Critical decisions

**Typical Distribution:**
- 50-70% Haiku
- 25-40% Sonnet
- 5-10% Opus

See [Model Selection Guide](../best-practices/model-selection.md) for details.

---

## Customization

### Add Your Own Agent

1. Copy template:
```bash
cp templates/agents/agent-template.md .claude/agents/my-agent.md
```

2. Customize:
- Set name and description
- Choose model (haiku/sonnet/opus)
- Select tools
- Define workflow

3. Test:
```
> Use my-agent to [task description]
```

See [Agent Design Best Practices](../best-practices/agent-design.md).

---

### Add Your Own Skill

1. Copy template:
```bash
cp templates/skills/skill-template.md .claude/skills/my-skill.md
```

2. Customize:
- Set name and description
- Write step-by-step instructions
- Add examples

3. Test:
```bash
/my-skill argument
```

See [Skill Authoring Best Practices](../best-practices/skill-authoring.md).

---

### Customize for Your Stack

1. Copy CLAUDE.md template:
```bash
cp templates/claude-md/nextjs-app.md CLAUDE.md
```

2. Update for your project:
- Replace placeholders
- Add project-specific patterns
- Document your conventions

3. Use with Claude:
```bash
claude
# Claude now understands your project structure
```

---

## Tips for Success

### 1. Start Small

Don't try to use everything at once:
1. Week 1: Use agents (automatic)
2. Week 2: Try worktrees for one feature
3. Week 3: Add planning workflow
4. Week 4: Create custom agent/skill

---

### 2. Monitor Costs

Track which agents you use most:
- Haiku agents are cheap (use freely)
- Sonnet agents are balanced (main workhorse)
- Opus agents are expensive (use strategically)

---

### 3. Keep Plans Updated

Plans are most useful when current:
- Update after each work session
- Check off completed tasks
- Add notes about decisions

---

### 4. Clean Up Regularly

Prevent clutter:
- Remove completed worktrees weekly
- Archive old plans
- Delete unused branches

---

### 5. Share with Team

If using per-project installation:
- Commit agents to git
- Commit skills to git
- Share plan templates
- Document team conventions

---

## Troubleshooting

### Agent Not Invoked

**Problem:** Claude doesn't delegate to your agent

**Solution:**
- Make description more specific
- Use action verbs ("Analyze", "Build", "Design")
- Match user's likely language

---

### Skill Not Found

**Problem:** `/my-skill` gives error

**Solution:**
```bash
# Check file exists
ls .claude/skills/my-skill.md

# Check name matches filename
grep "name:" .claude/skills/my-skill.md
```

---

### Worktree Already Exists

**Problem:** Can't create worktree

**Solution:**
```bash
# Use existing worktree
cd worktrees/feature-name

# OR remove and recreate
/worktree-cleanup feature-name
/worktree-create feature-name
```

---

### High Costs

**Problem:** Usage costs are too high

**Solution:**
- Use Haiku agents for exploration
- Limit Opus use to critical tasks
- Monitor agent usage
- See [Model Selection Guide](../best-practices/model-selection.md)

---

## Next Steps

### Learn More

- [Model Selection](../best-practices/model-selection.md) - Choose the right model
- [Agent Design](../best-practices/agent-design.md) - Create custom agents
- [Skill Authoring](../best-practices/skill-authoring.md) - Create custom skills
- [Worktree Workflow](../best-practices/worktree-workflow.md) - Master git worktrees

---

### Get Help

- Read documentation in `docs/`
- Check examples in `.claude/agents/` and `.claude/skills/`
- Review templates in `templates/`

---

### Contribute

Have a useful agent or skill?
1. Test thoroughly
2. Document well
3. Share with community

---

## Summary

**You now have:**
- 12 specialized sub-agents
- 12+ reusable skills
- Planning system with templates
- Git worktree workflow
- CLAUDE.md templates

**Start using:**
1. Let agents work automatically
2. Try `/worktree-create` for next feature
3. Use `/plan-status` to track progress
4. Explore with Haiku, implement with Sonnet, design with Opus

**Remember:**
- Agents are invoked automatically (or explicitly)
- Skills are invoked with `/skill-name`
- Plans track your progress
- Worktrees enable parallel work

Happy coding with Claude! 🎉
