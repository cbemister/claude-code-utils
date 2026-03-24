---
name: launch-app
description: Launch a new professional app from idea to staged build plan. Creates the project folder, configures the agent team, and generates all stage plans — ready for the team to build.
argument-hint: "[idea] - Optional: describe your app idea inline"
---

# Launch App

Turn an idea into a fully planned project — folder created, agent team configured, CLAUDE.md generated, and all stage plans written. The team can start building immediately.

## Instructions

**IMPORTANT: Execute immediately. If an idea was provided as an argument, proceed to Step 1. If not, use AskUserQuestion to ask what the user is building — do NOT print a menu and wait.**

---

## Step 1: Gather Requirements

### 1A: Get the Core Idea

If no idea was provided as a `$ARGS` argument, use **AskUserQuestion** to ask:

> "What are you building? Give me a quick description — what it does, who it's for, and any must-have features."

### 1B: Ask Clarifying Questions (2-3 max)

After getting the idea, ask **one batch of clarifying questions** (combine into a single AskUserQuestion):

1. **Target users** — Who is this for? (developers, consumers, internal teams, etc.)
2. **Key features** — What are the 3-5 core things it must do in v1?
3. **Tech preferences** — Any preferred language/framework, or should I recommend?

### 1C: Recommend Stack and Team

Based on the answers, recommend:

**Tech Stack** — Map the project type to the best option from this table:

| Stack | CLAUDE.md Template | Default Team | Best For |
|-------|-------------------|--------------|----------|
| Next.js | `nextjs-app.md` | `saas-product` | SaaS apps, dashboards, full-stack web |
| SvelteKit | `svelte.md` | `saas-product` | Performance-first web apps |
| Nuxt 3 | `vue.md` | `saas-product` | Vue-based full-stack apps |
| Express | `api-service.md` | `enterprise` | REST APIs, microservices |
| NestJS | `nestjs.md` | `enterprise` | Enterprise Node.js APIs |
| FastAPI | `python-app.md` | `enterprise` | Python APIs, ML services |
| Django | `django.md` | `enterprise` | Python web apps with ORM |
| Rails | `rails.md` | `enterprise` | Ruby full-stack apps |
| Go API | `go-api.md` | `enterprise` | High-performance Go services |
| React Native | `react-native.md` | `game-interactive` | Cross-platform mobile apps |
| Flutter | `flutter.md` | `game-interactive` | Cross-platform mobile/desktop |
| Electron | `nextjs-app.md` | `internal-tool` | Desktop apps with web tech |
| Rust CLI | `rust-cli.md` | `enterprise` | High-performance CLI tools |
| Node CLI | `cli-tool.md` | `enterprise` | Developer tools, automation |
| Astro | `astro.md` | `marketing-site` | Content sites, landing pages |
| Phaser Game | `game-browser.md` | `game-interactive` | Browser games |
| T3 Stack | `nextjs-app.md` | `saas-product` | tRPC + Next.js + Prisma apps |

**Agent Team** — Map to one of the 5 presets:

| Preset | Agents | Best For |
|--------|--------|----------|
| `saas-product` | ui-ux-designer, conversion-optimizer, backend-architect, frontend-architect, security-auditor, test-engineer, code-reviewer, performance-analyst | SaaS, B2B/B2C products, dashboards |
| `enterprise` | backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst | APIs, internal tools, complex backend |
| `internal-tool` | ui-ux-designer, backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst | Admin panels, dev tools, back-office |
| `game-interactive` | ui-ux-designer, mobile-designer, backend-architect, frontend-architect, test-engineer, performance-analyst | Games, interactive experiences, mobile |
| `marketing-site` | ui-ux-designer, mobile-designer, conversion-optimizer, frontend-architect, performance-analyst, code-reviewer | Landing pages, marketing sites |

Present the recommendation clearly:

```
Recommended for [project name]:

Tech Stack: [stack choice]
- Framework: [specific framework + version]
- Language: [TypeScript / Python / etc.]
- Database: [recommendation based on project type]
- Auth: [recommendation]
- Styling: [recommendation]
- Testing: [recommendation]

Agent Team: [team preset name]
- [list of agents]
- Best for: [why this team fits]

Shall I proceed with this, or would you like to adjust anything?
```

Wait for user confirmation or modifications before proceeding.

### 1D: Determine Project Name

If the user hasn't named the project, derive a name from the idea (kebab-case, lowercase) or ask:

> "What should we call this project? (This becomes the folder name)"

Store the final name as `PROJECT_NAME` (kebab-case).

---

## Step 2: Create Project Folder

**Create the project structure with plans and config only — no source code yet. Stage 0 handles scaffolding.**

### 2A: Determine Target Directory

The new project lives **one level up** from the current working directory:

```
TARGET_DIR="../$PROJECT_NAME"
```

Verify the directory doesn't already exist before proceeding. If it does, warn the user and ask for a different name.

### 2B: Initialize Repository

```bash
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
git init -q
```

### 2C: Copy Agent Team Configuration

Based on the selected team preset, copy the appropriate agents from `templates/enhance-app/.claude/agents/`:

**Agent files to copy per team:**

- `saas-product`: `ui-ux-designer.md`, `conversion-optimizer.md`, `backend-architect.md`, `frontend-architect.md`, `security-auditor.md`, `test-engineer.md`, `code-reviewer.md`, `performance-analyst.md`, `coordinator.md` (from `teams/saas-product/coordinator.md`)
- `enterprise`: `backend-architect.md`, `frontend-architect.md`, `security-auditor.md`, `test-engineer.md`, `devops-engineer.md`, `code-reviewer.md`, `performance-analyst.md`, `coordinator.md` (from `teams/enterprise/coordinator.md`)
- `internal-tool`: `ui-ux-designer.md`, `backend-architect.md`, `frontend-architect.md`, `security-auditor.md`, `test-engineer.md`, `devops-engineer.md`, `code-reviewer.md`, `performance-analyst.md`, `coordinator.md` (from `teams/internal-tool/coordinator.md`)
- `game-interactive`: `ui-ux-designer.md`, `mobile-designer.md`, `backend-architect.md`, `frontend-architect.md`, `test-engineer.md`, `performance-analyst.md`, `coordinator.md` (from `teams/game-interactive/coordinator.md`)
- `marketing-site`: `ui-ux-designer.md`, `mobile-designer.md`, `conversion-optimizer.md`, `frontend-architect.md`, `performance-analyst.md`, `code-reviewer.md`, `coordinator.md` (from `teams/marketing-site/coordinator.md`)

Source paths:
- Agent files: `[claude-code-utils]/templates/enhance-app/.claude/agents/[agent].md`
- Team coordinator: `[claude-code-utils]/templates/enhance-app/teams/[team-preset]/coordinator.md`

Destination: `$TARGET_DIR/.claude/agents/`

### 2D: Copy Rules Templates

Copy all rule files from `templates/enhance-app/.claude/rules/` to `$TARGET_DIR/.claude/rules/`:

- `api-conventions.md`
- `architecture.md`
- `code-standards.md`
- `env.md`
- `security-policy.md`
- `testing-standards.md`

### 2E: Copy Settings

Copy `templates/enhance-app/.claude/settings.json` to `$TARGET_DIR/.claude/settings.json`.

### 2F: Set Up Plans Directory

```
$TARGET_DIR/plans/
  active/           (empty — stage plans go here)
  templates/        (copy from templates/enhance-app/plans/templates/)
    stage-plan.md
    feature-plan.md
    bugfix-plan.md
    context-handoff.md
    master-plan-readme.md
```

Source: `[claude-code-utils]/templates/enhance-app/plans/templates/`

---

## Step 3: Generate CLAUDE.md

### 3A: Select Base Template

Use the CLAUDE.md template column from Step 1C. Read the template file from:

`[claude-code-utils]/templates/claude-md/[template-file]`

### 3B: Customize the Template

Replace all placeholders with actual project values:

| Placeholder | Replace With |
|-------------|-------------|
| `[Project Name]` | Actual project name (title case) |
| `[Description]` | 1-2 sentence description from requirements |
| `[Technology]` / `[Framework]` | Actual framework choice |
| Tech stack versions | Specific current versions (e.g., Next.js 15, TypeScript 5.x) |
| Generic commands | Actual dev/build/test commands for the stack |
| Team name reference | Selected team preset name |

If the selected stack differs from the base template's stack (e.g., SvelteKit using nextjs-app.md), add a section at the top documenting the actual stack and note that the template has been adapted.

### 3C: Add Agent Team Section

Append an **Agent Team** section to CLAUDE.md:

```markdown
## Agent Team

**Preset:** [team preset name]

| Agent | Role |
|-------|------|
| `coordinator` | Orchestrates tasks and synthesizes agent outputs |
| `[agent]` | [what they own in this project] |
| ... | ... |

**Invoke agents with:** Use the Agent/Task tool with the agent name to delegate work.
```

### 3D: Write CLAUDE.md

Write the customized content to `$TARGET_DIR/CLAUDE.md`.

---

## Step 4: Generate Stage Plans

Use the **Agent tool** to launch the `project-planner` agent (if available) or generate the plans directly.

### 4A: Plans to Generate

Generate the following in `$TARGET_DIR/plans/`:

1. **`plans/README.md`** — Master plan overview using `plans/templates/master-plan-readme.md` as the template. Fill in all sections with actual project details.

2. **All stage plan files** in `plans/active/` — named `stage-0-[title].md`, `stage-1-[title].md`, etc.

### 4B: Stage Structure Guidelines

Design stages appropriate for the project. Typical patterns:

**For web apps (Next.js, SvelteKit, etc.):**
- Stage 0: Foundation — repo init, tooling, CI/CD, base layout, env vars
- Stage 1: Data Layer — schema design, database setup, migrations, seed data
- Stage 2: Core API — primary endpoints, auth, validation
- Stage 3: Core UI — key screens, routing, components
- Stage 4: Business Logic — main feature implementation
- Stage 5: Testing & Polish — test coverage, accessibility, performance
- Stage 6: Deployment — hosting config, environment setup, monitoring

**For API services:**
- Stage 0: Foundation — project setup, server config, middleware
- Stage 1: Data Layer — schema, migrations, ORM setup
- Stage 2: Auth — authentication, authorization
- Stage 3: Core Endpoints — primary resource routes
- Stage 4: Advanced Features — secondary features
- Stage 5: Testing — integration tests, load tests
- Stage 6: Deployment — Docker, CI/CD, monitoring

**For CLI tools:**
- Stage 0: Foundation — project setup, commander config, build pipeline
- Stage 1: Core Commands — primary command implementation
- Stage 2: Advanced Commands — secondary commands
- Stage 3: Polish — help text, error messages, colors
- Stage 4: Testing & Distribution — test coverage, npm publishing

Adapt based on the actual project requirements from Step 1.

### 4C: Stage Plan Format

Each stage plan must use the template from `plans/templates/stage-plan.md` and be **fully detailed**:

- Real file paths for the project (not generic placeholders)
- Actual commands for the chosen stack
- Concrete code snippets showing key interfaces, function signatures, and patterns
- Specific test examples for what's being built
- Verification steps with expected output

**Quality bar:** Someone should be able to open a stage plan and start building immediately with no ambiguity.

### 4D: Agent Tool Invocation

If `project-planner` agent is available in the current project's `.claude/agents/`:

```
Use the Agent tool to invoke project-planner with:
- App description: [full requirements from Step 1]
- Tech stack: [chosen stack with specific versions]
- Agent team: [team preset with agent list]
- Target directory: [absolute path to $TARGET_DIR]
- Task: Generate plans/README.md and all plans/active/stage-*.md files
  following the templates in plans/templates/.
  All stages must be fully detailed with real file paths,
  actual commands, code snippets, and verification steps.
```

If `project-planner` is not available, generate the plans directly using the stage guidelines above.

---

## Step 5: Display Summary

After completing all steps, show a clean summary:

```
================================================================
  [PROJECT_NAME] is ready to build
================================================================

Location:    ../[project-name]/
Team:        [Team Preset Name]
Stack:       [Framework] + [Language] + [Database]

Agents:
  [list of agents, one per line with brief role]

Stage Roadmap:
  Stage 0: [Title] — [one line description]
  Stage 1: [Title] — [one line description]
  Stage 2: [Title] — [one line description]
  ...

Files Created:
  CLAUDE.md
  .claude/agents/     ([N] agents)
  .claude/rules/      (6 rule templates)
  .claude/settings.json
  plans/README.md     (master plan)
  plans/active/       ([N] stage plans)
  plans/templates/    (reusable templates)

Next Steps:
  1. cd ../[project-name]
  2. open plans/active/stage-0-[title].md
  3. Start building — the team is ready

Tip: Use the coordinator agent to delegate tasks to your team.
================================================================
```

---

## Reference: Tech Stack Decision Guide

Use this to make smart recommendations:

**Choose Next.js when:**
- Building a web app that needs both frontend and backend
- SEO matters (server-side rendering)
- TypeScript is preferred
- Team is JavaScript-focused

**Choose an API service (Express/FastAPI/NestJS) when:**
- Building a backend for a mobile app or separate frontend
- Microservices architecture
- API-only (no server-rendered UI needed)

**Choose Python (FastAPI/Django) when:**
- ML/AI features are involved
- Data processing is a core function
- Team prefers Python

**Choose a CLI tool when:**
- The primary interface is the terminal
- Building developer tooling
- No web UI needed

**Choose game-browser when:**
- Real-time interaction
- Canvas/WebGL rendering
- Game loop is the core architecture

**Choose marketing-site (Astro) when:**
- Mostly static content
- SEO is critical
- Minimal JavaScript needed

**Database recommendations by project type:**
- SaaS web app → PostgreSQL (via Prisma or Drizzle)
- API service → PostgreSQL or MongoDB (by data shape)
- CLI tool → SQLite or no database
- Marketing site → No database (or CMS like Contentlayer)
- Game → Redis (sessions) + PostgreSQL (persistence)
- Mobile backend → PostgreSQL

**Auth recommendations:**
- Next.js app → NextAuth.js or Clerk
- Express/NestJS API → JWT + Passport.js
- FastAPI → python-jose or FastAPI Users
- Marketing site → None needed (or Netlify Forms)
