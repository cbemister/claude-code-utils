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

**Use when:**
- Working on a team project
- Want skills version-controlled with your project
- Skills are project-specific

### Option 2: Personal Installation (Recommended for Individual Use)

Install skills to your personal `~/.claude/skills/` to use across ALL projects.

```bash
# Install all skills globally
./scripts/install-skills.sh

# Or install specific skill
./scripts/install-skills.sh create-plan
```

**Use when:**
- Want skills available in all your projects
- Personal workflow preferences
- Skills are general-purpose

### Required Structure

Each skill must be a directory with `SKILL.md` inside:
```
.claude/skills/           # Project-local
└── create-plan/
    └── SKILL.md

~/.claude/skills/         # Personal (global)
└── create-plan/
    └── SKILL.md
```

> **Note:** After adding skills or changing their location, restart Claude Code (close and reopen VSCode).

---

## Available Skills

### Development Workflow
- **ship** - Complete end-of-session workflow (verify → commit → summarize)
- **verify-work** - Pre-commit verification (security, best practices, code standards)
- **verify-performance** - Performance anti-pattern analysis and performance tests
- **organize-commits** - Group changes into logical commits with conventional format
- **track-progress** - Record work to changelog and progress tracking
- **summarize-session** - Capture structured session journal (decisions, state, next steps)

### Testing & Quality
- **generate-tests** - Generate test files following project patterns
- **browser-test** - Run Playwright browser tests across desktop, tablet, and mobile viewports
  - Auto-discovers routes and features from any web framework
  - Tests: navigation, forms, auth, CRUD, responsive, interactive, errors, user flows, performance
  - Generates reusable test scripts users can re-run
  - Captures screenshots at each viewport size

### Git Workflow
- **worktree-create** - Create git worktree for parallel development
- **worktree-sync** - Sync worktree with base branch
- **worktree-cleanup** - Remove completed worktrees

### Planning & Tracking
- **create-plan** - Initialize feature plan with phases
- **plan-status** - Show current plan progress
- **pm-review** - Product manager perspective — assess progress vs plan, identify priorities

### Design System
- **color-palette** - Transform generic colors into sophisticated, intentional palettes
- **typography-system** - Font pairings, type scales, fluid `clamp()` responsive sizing
- **spacing-system** - Hierarchical spacing with visual rhythm (not uniform gaps)
- **layout-asymmetry** - 60/40 splits, focal points, intentional asymmetry patterns
- **micro-interactions** - Hover, press, loading, and entrance animations
- **component-states** - Complete interactive states (hover, focus, active, disabled, loading)
- **component-polish** - Final production-quality polish pass on components
- **style** - Transform UI into any of 10 aesthetic themes: aurora, brutalist, cyberpunk, dark-premium, glassmorphism, minimalist, neumorphism, organic, retro, swiss
- **ui-transform** - Analyze existing UI for AI-generated patterns and transform to human-quality design

### Accessibility
- **accessibility-audit** - WCAG 2.1 AA compliance (contrast, semantics, keyboard, ARIA)
- **mobile-accessibility** - VoiceOver/TalkBack, screen readers, and mobile a11y
- **critique-value** - Evaluate work from end-user perspective (value, usability, completeness)

### Mobile & Responsive
- **mobile-patterns** - Mobile navigation, layout, and responsive patterns
- **touch-interactions** - Touch targets, gestures, haptics, and swipe actions

### Conversion Optimization
- **conversion-audit** - Audit pages for conversion issues and drop-off points
- **copywriting-guide** - Headlines, body copy, and microcopy frameworks
- **cta-optimizer** - CTA button design, placement, and copy psychology
- **social-proof** - Testimonials, logos, trust signals, and review patterns

### Design Enhancement (Chains)
- **enhance-design** - Comprehensive design workflow that chains all design skills
  - Phases: Analyze → Mobile Optimize → Conversion Optimize → Visual Polish
  - One command to enhance everything — like `/ship` for design work

### Framework-Specific
- **nextjs-optimization** - Server Components, loading states, image optimization, caching
- **electron-nextjs** - Add Electron to an existing Next.js project for desktop apps

### Project Scaffolding
- **starter-project** - Generate starter projects with agents/skills pre-configured
  - Categories: SaaS app, API service, component library, CLI tool, e-commerce, browser game
- **enhance-project** - Add Claude Code resources and improvements to existing projects
- **find-skills** - Discover and install skills for specific tasks

### Enterprise
- **enterprise-starter** - Scaffold a full enterprise Claude Code configuration layer for new projects
  - Creates: 8 specialist agents, .claude/rules/ knowledge base, hooks, plans, marketplace.json, MCP stubs
- **enterprise-enhance** - Add enterprise modules to an existing project (pick and choose)
  - Modules: agent-teams, rules, context-management, marketplace, hooks, MCP, CLAUDE.md snippets

## Usage

Skills are invoked with `/skill-name`:

```
/ship
/verify-work
/organize-commits
```

## Skill Chaining

Some skills automatically invoke others in sequence or parallel:
- `/ship` → `/verify-work` → `/organize-commits` → `/track-progress`
- `/enhance-design` → 4 phases with parallel execution (see below)
- `/enhance-project` → Analysis agents run in parallel

### Parallel Execution

Chaining skills now support parallel execution for independent operations:

**enhance-design:**
- Phase 2: `mobile-patterns`, `touch-interactions`, `mobile-accessibility` run in parallel
- Phase 3: `copywriting-guide`, `cta-optimizer`, `social-proof` run in parallel
- Phase 4: Three batches of parallel execution for visual polish

**enhance-project:**
- Analysis: `codebase-explorer`, `dependency-analyzer`, `pattern-finder` run in parallel
- Quality checks: `verify-work` and `performance-check` run in parallel

### Hooks Integration

Chaining skills now include hooks for better visibility and quality gates:

**Agent Notifications:**
- `SubagentStart` hooks show which agent is running
- `SubagentStop` hooks confirm completion
- Provides real-time visibility into background operations

**Quality Gates:**
- `Stop` hooks verify all phases completed successfully
- Prevents incomplete skill execution
- Validates that all required steps ran

## Creating Custom Skills

See [Skill Authoring Best Practices](../../docs/best-practices/skill-authoring.md) for guidelines.
