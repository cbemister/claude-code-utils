# Claude Code Software Factory

## Overview
This repository is a software factory that builds professional apps and evolves them for revenue. Run `/factory launch` to go from an idea to a deployed product, then `/factory evolve` to continuously optimize it with AI-driven evaluation, hypothesis generation, and autonomous implementation.

The factory pipeline: **idea → plan → build → evaluate → hypothesize → optimize → preview → human approve → deploy → repeat**.

Supports 17 tech stacks (Next.js, SvelteKit, Nuxt, Express, NestJS, FastAPI, Django, Rails, Go, React Native, Flutter, Electron, Rust CLI, Node CLI, Astro, Phaser, T3) and 5 agent team presets.

## Project Structure
```
.claude/
├── agents/           # Sub-agents by category
│   ├── design/       # ui-ux-designer, mobile-designer, conversion-optimizer (Opus)
│   ├── explore/      # Codebase exploration agents (Haiku)
│   ├── plan/         # project-planner, architecture-planner, feature-planner (Opus)
│   └── implement/    # Implementation agents (Sonnet)
├── commands/         # Slash commands (git, plan, project)
└── skills/           # 40+ skills including launch-app, plan-next-stage

templates/
├── claude-md/        # 17 CLAUDE.md templates for different tech stacks
├── stage-libraries/  # Stage progression references for 7 project archetypes
└── enhance-app/      # Agent teams, rules, hooks, plans, MCP config

docs/                 # Documentation and best practices
scripts/              # install-skills.sh
```

## Key Conventions

### Sub-Agent Format
Agents are Markdown files with YAML frontmatter:
```yaml
---
name: agent-name
description: When to use this agent
tools: Read, Grep, Glob
model: haiku | sonnet | opus | inherit
skills:
  - skill-name   # Skills the agent can invoke
---
```

### Model Selection
- **Haiku**: Fast, cheap — use for exploration and simple tasks
- **Sonnet**: Balanced — use for implementation and reviews
- **Opus**: Powerful — use for architecture and complex planning

### Skill Format
Skills are directories with a `SKILL.md` file:
```
.claude/skills/
└── skill-name/
    └── SKILL.md    # Frontmatter + instructions
```

SKILL.md format:
```yaml
---
name: skill-name
description: What this skill does
args: "[arg] - Optional: description"  # if skill accepts args
---
```

### Skills Installation
```bash
# Install all skills globally (available in every project)
./scripts/install-skills.sh

# Or install specific skill
./scripts/install-skills.sh typography-system
```

Project-local skills in `.claude/skills/` work immediately — no install needed. Restart Claude Code after adding new skills.

## Adding New Resources

### New Agent
1. Create file in `.claude/agents/<category>/<name>.md`
2. Add YAML frontmatter with name, description, tools, model, and optional skills list
3. Write system prompt in markdown body
4. Update agents README

### New Skill
1. Create directory `.claude/skills/<name>/`
2. Create `SKILL.md` file inside
3. Add YAML frontmatter with name and description
4. Write instructions in markdown
5. Restart Claude Code to test
6. Update [.claude/skills/README.md](.claude/skills/README.md)

## Key Skills Reference

| Category | Skills |
|----------|--------|
| Evolution | factory, evaluate-product, generate-hypotheses, plan-optimization, preview-deploy, evolution-gate |
| Workflow | ship, verify-work, verify-performance, organize-commits, summarize-session |
| Design System | color-palette, typography-system, spacing-system, layout-asymmetry, micro-interactions, component-states, component-polish, style, ui-transform |
| Accessibility | accessibility-audit, mobile-accessibility, critique-value |
| Mobile | mobile-patterns, touch-interactions |
| Conversion | conversion-audit, copywriting-guide, cta-optimizer, social-proof |
| Enterprise | enhance-app |
| Autonomous Build | build-app |
| Scaffolding | launch-app, design-app, starter-project, enhance-project, find-skills |
| Framework | nextjs-optimization, electron-nextjs |
| Planning | launch-app, plan-next-stage, create-plan, plan-status, pm-review |
