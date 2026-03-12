# Agent Teams

Choose a team preset when running `/enhance-app`. Each team is optimized for a specific application type with the right mix of engineering and specialist agents. All teams are build-focused — design is applied separately after the build using design skills.

## Quick Comparison

| Team | Engineering Agents | Total | Model Cost |
|------|-------------------|-------|------------|
| Enterprise Engineering | backend, frontend, security, test, devops, review, perf | 8 | 1 Opus + 7 Sonnet |
| SaaS Product | backend, frontend, security, test, review, perf | 7 | 1 Opus + 6 Sonnet |
| Internal Tool | backend, frontend, security, test, devops, review, perf | 8 | 1 Opus + 7 Sonnet |
| Game / Interactive | backend, frontend, test, perf | 5 | 1 Opus + 4 Sonnet |
| Marketing Site | frontend, perf, review | 4 | 1 Opus + 3 Sonnet |

## When to Choose Each Team

### Enterprise Engineering (default)
**Choose when:** Your project is primarily engineering-focused — APIs, data pipelines, complex backends, full-stack apps. You want the broadest engineering coverage including DevOps.

**Includes:** coordinator + backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → security-auditor (if auth changes)
           → test-engineer → code-reviewer
```

---

### SaaS Product
**Choose when:** You're building a SaaS product and need full-stack engineering with security, testing, and performance. No DevOps — suited for managed platforms (Vercel, Railway, etc.).

**Includes:** coordinator + backend-architect, frontend-architect, security-auditor, test-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → security-auditor (if auth changes)
           → test-engineer → code-reviewer
```

**Key difference:** Same as Enterprise minus DevOps. Lighter weight for managed-infra projects.

---

### Internal Tool
**Choose when:** You're building admin panels, internal dashboards, developer tools, or back-office apps. Full engineering plus DevOps for internal deployment.

**Includes:** coordinator + backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → devops-engineer (deployment)
           → security-auditor → test-engineer → code-reviewer
```

**Key difference:** Same agents as Enterprise. Coordinator prioritizes reliability and maintainability over feature richness.

---

### Game / Interactive
**Choose when:** You're building games, interactive experiences, creative tools, or canvas-heavy apps. Lean team focused on performance-critical engineering.

**Includes:** coordinator + backend-architect, frontend-architect, test-engineer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → performance-analyst (60fps verification)
           → test-engineer
```

**Key difference:** Lean team — no security/devops/review overhead. Performance is the primary constraint.

---

### Marketing Site
**Choose when:** You're building landing pages, marketing sites, or frontend-only projects. Lightweight frontend team with performance and code quality focus.

**Includes:** coordinator + frontend-architect, performance-analyst, code-reviewer

**Workflow:**
```
coordinator → frontend-architect (implementation)
           → performance-analyst (Core Web Vitals)
           → code-reviewer
```

**Key difference:** Frontend-only — no backend agents. Smallest team for the simplest projects.

## Applying Design After Build

Design is applied as a separate pass using design skills, not during the initial build. This produces better results because you can guide the aesthetic interactively.

```bash
# After building, apply design with skills:
/style dark-premium          # Apply a themed aesthetic
/color-palette               # Refine color scheme
/typography-system           # Set up font hierarchy
/enhance-design              # Full design pass (chains all design skills)
```

## Head-to-Head Competition

Use `/team-battle` to run two different teams on the same task and compare results:

```
/team-battle "Build a user settings page"
```

This creates two worktrees, installs different teams in each, runs the same task, and presents a side-by-side comparison so you can pick the best approach.

## Customizing Teams

Edit `teams.json` to create custom team compositions. Each team needs:
- A list of agents from the pool (see `.claude/agents/README.md`)
- A custom `coordinator.md` in its team directory with the right roster table
