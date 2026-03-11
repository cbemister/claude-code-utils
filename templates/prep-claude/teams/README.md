# Agent Teams

Choose a team preset when running `/prep-claude`. Each team is optimized for a specific application type with the right mix of design, engineering, and specialist agents.

## Quick Comparison

| Team | Design Agents | Engineering Agents | Total | Model Cost |
|------|--------------|-------------------|-------|------------|
| Enterprise Engineering | None | backend, frontend, security, test, devops, review, perf | 8 | 1 Opus + 7 Sonnet |
| SaaS Product | UI/UX, Conversion | backend, frontend, security, test, review, perf | 9 | 1 Opus + 8 Sonnet |
| Internal Tool | UI/UX (practical) | backend, frontend, security, test, devops, review, perf | 9 | 1 Opus + 8 Sonnet |
| Game / Interactive | UI/UX, Mobile | backend, frontend, test, perf | 7 | 1 Opus + 6 Sonnet |
| Marketing Site | UI/UX, Mobile, Conversion | frontend, perf, review | 7 | 1 Opus + 6 Sonnet |

## When to Choose Each Team

### Enterprise Engineering (default)
**Choose when:** Your project is primarily engineering-focused — APIs, data pipelines, internal tools that don't need design polish. You want the broadest engineering coverage including DevOps.

**Includes:** coordinator + backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → security-auditor (if auth changes)
           → test-engineer → code-reviewer
```

---

### SaaS Product
**Choose when:** You're building a SaaS product where design quality drives revenue. You need polished UI, conversion-optimized flows, and full engineering support. Dashboards, B2B/B2C apps, subscription products.

**Includes:** coordinator + ui-ux-designer, conversion-optimizer, backend-architect, frontend-architect, security-auditor, test-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → ui-ux-designer (design system + visual specs)
           → conversion-optimizer (CTAs, copy, social proof)
           → backend-architect + frontend-architect (parallel, from design specs)
           → security-auditor → test-engineer → code-reviewer
```

**Key difference:** Design-first workflow. UI/UX designer creates specs before frontend-architect implements.

---

### Internal Tool
**Choose when:** You're building admin panels, internal dashboards, developer tools, or back-office apps. You need functional, usable design (not flashy) plus full engineering and DevOps support.

**Includes:** coordinator + ui-ux-designer, backend-architect, frontend-architect, security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst

**Workflow:**
```
coordinator → backend-architect + frontend-architect (parallel)
           → ui-ux-designer (practical layout, component states)
           → devops-engineer (deployment)
           → test-engineer → code-reviewer
```

**Key difference:** UI/UX designer focuses on usability (data tables, forms, admin flows) rather than visual polish. Includes DevOps for internal deployment.

---

### Game / Interactive
**Choose when:** You're building games, interactive experiences, creative tools, or canvas-heavy apps. You need rich visual design, smooth touch interactions, and performance-critical engineering.

**Includes:** coordinator + ui-ux-designer, mobile-designer, backend-architect, frontend-architect, test-engineer, performance-analyst

**Workflow:**
```
coordinator → mobile-designer (interaction patterns, gestures)
           → ui-ux-designer (visual design, animations)
           → backend-architect + frontend-architect (parallel)
           → performance-analyst (60fps verification)
           → test-engineer
```

**Key difference:** Two design agents — mobile-designer handles touch/interaction patterns while ui-ux-designer handles visual design. Performance is prioritized throughout.

---

### Marketing Site
**Choose when:** You're building landing pages, marketing sites, pricing pages, or product launches. Maximum design firepower with all three design agents, focused on conversion.

**Includes:** coordinator + ui-ux-designer, mobile-designer, conversion-optimizer, frontend-architect, performance-analyst, code-reviewer

**Workflow:**
```
coordinator → conversion-optimizer (strategy, copy, CTAs)
           → ui-ux-designer (visual design system)
           → mobile-designer (mobile-first responsive)
           → frontend-architect (implement from specs)
           → performance-analyst (Core Web Vitals)
           → code-reviewer
```

**Key difference:** Conversion strategy comes first. All three design agents collaborate. No backend — marketing sites are frontend-only.

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
