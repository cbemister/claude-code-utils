# Skills

Workflow automations and reusable procedures for development tasks.

## Installation Options

Claude Code discovers skills from three locations:
1. **Project** - `.claude/skills/<name>/SKILL.md` (this directory!)
2. **Personal** - `~/.claude/skills/<name>/SKILL.md`
3. **Enterprise** - Managed by your organization

### Option 1: Project-Local (Recommended for Teams)

**Skills in this directory work immediately** - no installation needed!

This repo's skills are already in `.claude/skills/` and will work in any project that includes this repo. Just restart Claude Code.

### Option 2: Personal Installation (Recommended for Individual Use)

Install skills to your personal `~/.claude/skills/` to use across ALL projects.

```bash
# Install all skills globally
./scripts/install-resources.sh

# Or install specific skill
./scripts/install-resources.sh create-plan
```

### Required Structure

Each skill must be a directory with `SKILL.md` inside:
```
.claude/skills/
└── create-plan/
    └── SKILL.md
```

> **Note:** After adding skills or changing their location, restart Claude Code.

---

## Available Skills (29)

### Evolution & Software Factory
- **factory** - Top-level orchestrator: launch, build, evolve, status, list
- **evaluate-product** - Composite 0-100 score across 7 dimensions
- **generate-hypotheses** - Ranked optimization proposals from evaluation data
- **plan-optimization** - Convert hypotheses into executable stage plans
- **evolution-gate** - Deploy preview + human approve/reject gate (`deploy`, `approve`, `reject`)

### Autonomous Build
- **build-app** - Autonomously build an app from staged plans (loops across context windows, Slack notifications)

### Project Scaffolding
- **launch-app** - Go from idea to staged build plan + full Claude Code config
- **design-app** - Generate multiple design concepts, compare, implement chosen direction
- **starter-project** - Generate starter projects pre-configured with agents and skills
- **enhance-app** - Add agents, rules, hooks, plans, MCP to any project

### Workflow
- **ship** - End-of-session workflow (verify → commit → summarize)
- **verify-work** - Pre-commit verification: security, code standards, performance patterns
- **organize-commits** - Group changes into logical conventional commits
- **summarize-session** - Capture structured session journal (decisions, state, next steps)

### Git
- **worktree** - Manage git worktrees (`create`, `sync`, `cleanup`)

### Planning
- **create-plan** - Initialize a feature plan with phases and task tracking
- **plan-status** - Show plan progress; `refresh <stage-file>` to sync against codebase
- **pm-review** - Product manager perspective — assess progress, identify gaps

### Design
- **enhance-design** - Full design pass: audit → mobile → conversion → visual polish (`quick`, `mobile`, `conversion`)
- **design-system** - Colors, typography, spacing, layout (`colors`, `typography`, `spacing`, `layout`)
- **component-polish** - States, interactions, and final refinement (`states`, `interactions`)
- **style** - Transform UI into a visual theme (aurora, brutalist, cyberpunk, dark-premium, glassmorphism, minimalist, neumorphism, organic, retro, swiss)
- **ui-transform** - Analyze and transform AI-generated UI patterns

### Conversion & Marketing
- **conversion-audit** - Audit and optimize for conversion (`copy`, `cta`, `social-proof`, or full)
- **critique-value** - Evaluate from end-user perspective (value, usability, completeness)

### Accessibility & Mobile
- **accessibility-audit** - WCAG 2.1 AA audit + mobile screen reader support (VoiceOver/TalkBack)
- **mobile-design** - Mobile-first patterns and touch interactions (`patterns`, `touch`)
- **browser-test** - Playwright tests across desktop, tablet, mobile

### Testing
- **generate-tests** - Generate comprehensive test files following project patterns

---

## Skill Chaining

Some skills automatically invoke others:

- `/ship` → `/verify-work` → `/organize-commits` → `/summarize-session`
- `/enhance-design` → `/conversion-audit` → `/mobile-design` → `/conversion-audit copy/cta/social-proof` → `/design-system` → `/component-polish`
- `/factory evolve` → `/evaluate-product` → `/generate-hypotheses` → `/plan-optimization` → `/build-app` → `/evolution-gate`
- `/build-app` → stage plans → `/verify-work` → commit (per stage)

---

## Creating Custom Skills

See [Skill Authoring Best Practices](../../docs/best-practices/skill-authoring.md) for guidelines.
