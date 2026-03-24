# Skills Catalog

## Overview

Skills are workflow automations invoked with `/skill-name`. Each skill is a directory containing a `SKILL.md` file with YAML frontmatter and instructions.

## Skill Categories

### Autonomous Build
| Skill | Purpose |
|---|---|
| `build-app` | Autonomously build app from staged plans (loops across context windows, Slack notifications) |

### Evolution & Software Factory
| Skill | Purpose |
|---|---|
| `factory` | Top-level orchestrator — launch, build, evolve, status, list. Manages project registry |
| `evaluate-product` | Composite 0-100 score across 7 dimensions (conversion, revenue, UX, perf, a11y, completeness, code quality) |
| `generate-hypotheses` | Ranked optimization proposals from evaluation data, batched 2-3 per cycle |
| `plan-optimization` | Convert hypotheses into standard stage plans for `/build-app` |
| `evolution-gate` | Deploy preview + human approve/reject gate (`deploy`, `approve`, `reject`) |

### Workflow Skills
| Skill | Purpose |
|---|---|
| `ship` | End-of-session: verify, commit, summarize |
| `verify-work` | Pre-commit security, code quality, and performance pattern checks |
| `organize-commits` | Group changes into logical conventional commits |
| `summarize-session` | Capture session context for continuity |

### Git
| Skill | Purpose |
|---|---|
| `worktree` | Manage git worktrees (`create`, `sync`, `cleanup`) |

### Design
| Skill | Purpose |
|---|---|
| `enhance-design` | Full design pass: audit → mobile → conversion → polish (`quick`, `mobile`, `conversion`) |
| `design-system` | Colors, typography, spacing, layout (`colors`, `typography`, `spacing`, `layout`) |
| `component-polish` | States, interactions, and final refinement (`states`, `interactions`) |
| `style` | Transform UI into themed aesthetic (10 themes) |
| `ui-transform` | Comprehensive UI analysis and transformation |

### Accessibility & Mobile
| Skill | Purpose |
|---|---|
| `accessibility-audit` | WCAG 2.1 AA + mobile screen reader support (VoiceOver/TalkBack) |
| `mobile-design` | Mobile-first patterns and touch interactions (`patterns`, `touch`) |
| `browser-test` | Playwright tests across desktop, tablet, mobile |

### Conversion & Marketing
| Skill | Purpose |
|---|---|
| `conversion-audit` | Audit and optimize for conversion (`copy`, `cta`, `social-proof`, or full) |
| `critique-value` | Evaluate from end-user perspective (value, usability, completeness) |

### Project Setup
| Skill | Purpose |
|---|---|
| `enhance-app` | Full project setup (agents, rules, hooks, plans, MCP) |
| `design-app` | Generate multiple design concepts, compare, and implement chosen direction |
| `starter-project` | Generate new projects with Claude Code config |

### Planning
| Skill | Purpose |
|---|---|
| `create-plan` | Initialize a feature plan |
| `plan-status` | Show plan progress; `refresh <stage-file>` to sync against codebase |
| `pm-review` | Product manager assessment |

### Testing
| Skill | Purpose |
|---|---|
| `generate-tests` | Generate comprehensive test files following project patterns |

### Framework-Specific
| Skill | Purpose |
|---|---|
| `nextjs-optimization` | Server Components, loading states, image optimization |
| `electron-nextjs` | Add Electron to Next.js projects |

## Skill Format

```
.claude/skills/
└── skill-name/
    └── SKILL.md
```

```yaml
---
name: skill-name
description: What this skill does
argument-hint: "[arg] — Optional: description"
---

[Instructions in markdown]
```

## Installation

Project-local skills work immediately. For global installation:
```bash
./scripts/install-resources.sh              # all skills
./scripts/install-resources.sh skill-name   # specific skill
```
