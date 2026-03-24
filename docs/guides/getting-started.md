# Getting Started

Welcome to the Claude Code App Launchpad — a toolkit for launching professional apps with AI agent teams.

## What is This?

You come here with an app idea. An agent scaffolds your project folder, generates staged build plans, configures an agent team, and hands everything off so the team can start building immediately. Two primary workflows:

- **`/launch-app`** — Start a new app from scratch (idea to fully planned project)
- **`/enhance-app`** — Add agents, teams, rules, and plans to an existing project

---

## Launch a New App

This is the primary workflow. Run it from the claude-code-utils directory:

```
/launch-app
```

### What Happens

1. **Describe your idea** — What you're building, who it's for, must-have features
2. **Answer 2-3 questions** — Target users, key features, tech preferences
3. **Review recommendation** — Claude recommends a tech stack and agent team
4. **Project gets created** — Folder, CLAUDE.md, agents, rules, and all stage plans

### What You Get

```
your-app/
  CLAUDE.md                    # Filled in for your stack (not placeholders)
  .claude/
    agents/                    # Your agent team (5-9 agents)
    rules/                     # Architecture, API, security, testing standards
    settings.json              # Safety hooks
  plans/
    README.md                  # Master plan with dependency graph
    active/
      stage-0-foundation.md    # Every stage fully detailed
      stage-1-data-layer.md
      stage-2-api.md
      ...
    templates/                 # Reusable plan templates
```

No starter code is generated — Stage 0 handles scaffolding. This keeps the project clean and lets the agent team make real decisions during implementation.

### Supported Tech Stacks (17)

| Stack | Best For |
|-------|----------|
| Next.js / T3 Stack | SaaS apps, dashboards, full-stack web |
| SvelteKit | Performance-first web apps |
| Nuxt 3 | Vue-based full-stack apps |
| Express | REST APIs, microservices |
| NestJS | Enterprise Node.js APIs |
| FastAPI | Python APIs, ML services |
| Django | Python web apps with ORM |
| Rails | Ruby full-stack apps |
| Go API | High-performance Go services |
| React Native | Cross-platform mobile apps |
| Flutter | Cross-platform mobile/desktop |
| Electron | Desktop apps with web tech |
| Rust CLI | High-performance CLI tools |
| Node CLI | Developer tools, automation |
| Astro | Content sites, landing pages |
| Phaser Game | Browser games |

---

## Build Stage by Stage

After `/launch-app` creates your project, open it and start building:

```bash
cd ../your-app
```

### 1. Open the First Stage

```bash
# Check the master plan
cat plans/README.md

# Open stage 0
cat plans/active/stage-0-foundation.md
```

Each stage plan contains:
- **Why this stage** — Business context, not just technical deliverables
- **Architecture** — How pieces fit together (with ASCII diagrams)
- **Tasks** — Numbered (0A, 0B, 0C), each with assigned agent, file list, steps, tests, and verification
- **Parallelization** — Which tasks can run simultaneously
- **Deliverable verification** — Unit tests, integration tests, regression checks, checklist

### 2. Work Through Tasks

Each task follows this flow:

```
Steps → Test → Verify → Commit
```

Tasks are designed to be handed to agents. For example:

```
Use the backend-architect agent to implement Task 1A (database schema setup)
```

Or use the coordinator agent to delegate across the team:

```
Use the coordinator agent to work through Stage 1 tasks
```

### 3. Complete the Stage

After all tasks pass their verification steps, run the **Stage Deliverable Verification** at the bottom of each stage plan:

- All unit tests pass
- Integration test works end-to-end
- No regressions in the full test suite
- Checklist items checked off

### 4. Archive and Move On

```bash
# Move completed stage to archive
mv plans/active/stage-0-foundation.md plans/archive/

# Update the master plan README (mark stage as complete)

# Open the next stage
cat plans/active/stage-1-data-layer.md
```

---

## Refresh Plans for Codebase Drift

As you build stages, the codebase may diverge from what was planned — different file paths, new patterns, architectural decisions. Use `/plan-next-stage` to update a future stage plan:

```
/plan-next-stage stage-4-ui-shell
```

This:
1. Reads the existing stage plan
2. Scans what was actually built in prior stages
3. Updates file paths, imports, and code snippets to match reality
4. Adjusts for architectural decisions made during earlier stages
5. Writes the updated plan back

This is optional but useful when earlier stages introduced changes that affect later plans.

---

## Add to an Existing Project

Already have a project? Use `/enhance-app` to add Claude Code configuration:

```
/enhance-app
```

This scans your project and installs what's missing:
- **Agent team** — Choose from 5 presets (enterprise, saas-product, internal-tool, game-interactive, marketing-site)
- **Rules** — Architecture, API conventions, security policy, testing standards, code standards, environment variables
- **Hooks** — Safety hooks for secrets, formatting, type checking
- **Plan templates** — Stage plans, feature plans, bugfix plans, context handoffs
- **CLAUDE.md** — Generated from a template matched to your stack

---

## Agent Teams

Every project gets a team of specialized agents. Each team has a **coordinator** that delegates work.

| Team | Agents | Best For |
|------|--------|----------|
| Enterprise Engineering | 8 (no designers) | APIs, data pipelines, complex backends |
| SaaS Product | 9 (UI/UX + Conversion) | SaaS apps, dashboards, subscription products |
| Internal Tool | 9 (UI/UX practical) | Admin panels, developer tools |
| Game / Interactive | 7 (UI/UX + Mobile) | Games, creative tools, mobile apps |
| Marketing Site | 7 (all 3 designers) | Landing pages, marketing sites |

### Agent Roster

| Agent | Model | Specialty |
|-------|-------|-----------|
| `coordinator` | Opus | Orchestrates task delegation and synthesis |
| `backend-architect` | Sonnet | System design, database schema, API architecture |
| `frontend-architect` | Sonnet | UI architecture, component design, state management |
| `security-auditor` | Sonnet | Auth, input validation, dependency audits |
| `test-engineer` | Sonnet | Test strategy, coverage, TDD |
| `devops-engineer` | Sonnet | CI/CD, Docker, infrastructure |
| `code-reviewer` | Sonnet | Code quality, patterns, best practices |
| `performance-analyst` | Sonnet | Profiling, optimization, load testing |
| `ui-ux-designer` | Opus | Design systems, visual design, brand-driven interfaces |
| `mobile-designer` | Opus | Mobile-first UX, thumb zones, platform patterns |
| `conversion-optimizer` | Opus | Conversion psychology, copywriting, CTAs |

See [Team Selection Guide](../../templates/enhance-app/teams/README.md) for detailed comparison.

---

## Key Skills Reference

### App Lifecycle
| Skill | Purpose |
|-------|---------|
| `/launch-app` | New app: idea to fully planned project |
| `/enhance-app` | Add agents, teams, rules to existing project |
| `/plan-next-stage` | Refresh a stage plan for codebase drift |

### Planning
| Skill | Purpose |
|-------|---------|
| `/create-plan` | Initialize a feature plan |
| `/plan-status` | Show plan progress |
| `/pm-review` | Product manager assessment |

### Development
| Skill | Purpose |
|-------|---------|
| `/worktree-create` | Create worktree + branch for parallel development |
| `/worktree-sync` | Sync worktree with main branch |
| `/worktree-cleanup` | Remove completed worktrees |
| `/generate-tests` | Generate test suites for code |
| `/verify-work` | Pre-commit quality and security check |
| `/verify-performance` | Performance audit |

### Ship
| Skill | Purpose |
|-------|---------|
| `/organize-commits` | Group changes into logical commits |
| `/ship` | End-of-session workflow (verify, commit, track) |
| `/summarize-session` | Capture context for next session |

### Design (Opus agents)
| Skill | Purpose |
|-------|---------|
| `/color-palette` | Professional color schemes |
| `/typography-system` | Font pairings and hierarchy |
| `/spacing-system` | Visual rhythm and spacing |
| `/ui-transform` | Full UI analysis and transformation |
| `/conversion-audit` | Conversion optimization review |

---

## Model Selection

Agents use different models based on task complexity:

| Model | Cost | Use For | Agents |
|-------|------|---------|--------|
| **Haiku** | Cheapest | Exploration, search, pattern finding | codebase-explorer, dependency-analyzer, pattern-finder |
| **Sonnet** | Balanced | Implementation, reviews, testing | Most engineering agents |
| **Opus** | Premium | Architecture, design, complex planning | coordinator, designers, project-planner |

**Target distribution:** 50-70% Haiku, 25-40% Sonnet, 5-10% Opus

See [Model Selection Guide](../best-practices/model-selection.md) for details.

---

## Common Workflows

### New Feature (During a Build)

```bash
/worktree-create user-notifications
cd worktrees/user-notifications

# Work on the feature using agents
# Use the backend-architect to design the notification system
# Use the test-engineer to write tests

/worktree-sync          # Sync with main periodically
/ship                   # When done
/worktree-cleanup user-notifications  # After merge
```

### Bug Fix

```bash
/create-plan login-fix --template=bugfix

# Use the debugger agent to investigate
# Fix and test
/verify-work
/ship
```

### Compare Agent Teams

```bash
/team-battle
# Runs two teams on the same task in separate worktrees
# Side-by-side comparison of results
```

---

## Troubleshooting

### `/launch-app` Creates Empty Plans

The project-planner agent needs access to the stage library files in `templates/stage-libraries/`. Make sure you're running `/launch-app` from the claude-code-utils directory.

### Agents Not Delegating

Make sure `.claude/agents/` contains the agent files and `.claude/settings.json` exists in your project. Run `/enhance-app` to fix missing configuration.

### Stage Plan References Wrong Paths

Run `/plan-next-stage stage-N-title` to refresh the stage plan against the actual codebase.

### Skills Not Found

Skills require the `.claude/skills/` directory. Run the install script to make skills available globally:

```bash
./scripts/install-resources.sh
```

Restart Claude Code after installing new skills.

---

## Next Steps

- [Model Selection Guide](../best-practices/model-selection.md) — Optimize costs
- [Agent Design](../best-practices/agent-design.md) — Create custom agents
- [Skill Authoring](../best-practices/skill-authoring.md) — Create custom skills
- [Worktree Workflow](../best-practices/worktree-workflow.md) — Parallel development
- [Team Selection](../../templates/enhance-app/teams/README.md) — Compare agent teams
