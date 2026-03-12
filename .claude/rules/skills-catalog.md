# Skills Catalog

## Overview

Skills are workflow automations invoked with `/skill-name`. Each skill is a directory containing a `SKILL.md` file with YAML frontmatter and instructions.

## Skill Categories

### Workflow Skills
| Skill | Purpose |
|---|---|
| `ship` | End-of-session: verify, commit, track |
| `verify-work` | Pre-commit security + quality checks |
| `verify-performance` | Performance anti-pattern detection |
| `organize-commits` | Group changes into logical conventional commits |
| `summarize-session` | Capture session context for continuity |

### Design System Skills
| Skill | Purpose |
|---|---|
| `color-palette` | Professional color schemes (anti-AI oversaturation) |
| `typography-system` | Font hierarchy, pairings, readability |
| `spacing-system` | Intentional spacing with visual rhythm |
| `layout-asymmetry` | Break symmetry with 60/40 or 70/30 splits |
| `micro-interactions` | Subtle hover/focus/transition animations |
| `component-states` | Hover, focus, active, disabled, loading states |
| `component-polish` | Final pass elevating good to excellent |
| `style` | Transform UI into themed aesthetic (10 themes) |
| `ui-transform` | Comprehensive UI analysis and transformation |

### Accessibility & Mobile
| Skill | Purpose |
|---|---|
| `accessibility-audit` | WCAG 2.1 Level AA compliance |
| `mobile-accessibility` | VoiceOver/TalkBack, touch targets |
| `mobile-patterns` | Mobile nav, layout, responsive strategies |
| `touch-interactions` | Touch targets, swipe, pull-to-refresh |

### Conversion & Marketing
| Skill | Purpose |
|---|---|
| `conversion-audit` | Audit pages for conversion opportunities |
| `copywriting-guide` | PAS/AIDA/BAB frameworks for copy |
| `cta-optimizer` | CTA button design and psychology |
| `social-proof` | Testimonials, logos, stats, reviews |

### Project Setup
| Skill | Purpose |
|---|---|
| `enhance-app` | Full project setup (agents, rules, hooks, plans, MCP) |
| `design-app` | Generate multiple design concepts, compare, and implement chosen direction |
| `starter-project` | Generate new projects with Claude Code config |
| `enhance-project` | Add Claude Code features to existing projects |
| `find-skills` | Discover and install skills |

### Planning
| Skill | Purpose |
|---|---|
| `create-plan` | Initialize a feature plan |
| `plan-status` | Show progress of active plans |
| `pm-review` | Product manager assessment |

### Framework-Specific
| Skill | Purpose |
|---|---|
| `nextjs-optimization` | Server Components, loading states, image optimization |
| `electron-nextjs` | Add Electron to Next.js projects |
| `frontend-design` | Frontend design guidance |

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
args: "[arg] - Optional: description"
---

[Instructions in markdown]
```

## Installation

Project-local skills work immediately. For global installation:
```bash
./scripts/install-skills.sh              # all skills
./scripts/install-skills.sh skill-name   # specific skill
```
