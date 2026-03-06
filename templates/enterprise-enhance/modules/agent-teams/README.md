# Agent Teams Module

Eight specialized enterprise agents for coordinated development workflows.

## Installation

Copy all `.md` files from this directory to `.claude/agents/` in your project:

```bash
# From your project root:
cp path/to/enterprise-enhancement/modules/agent-teams/*.md .claude/agents/
```

Restart Claude Code to activate.

## Agents Included

| File | Agent | Model | Role |
|---|---|---|---|
| `coordinator.md` | coordinator | Opus | Orchestrates team, decomposes complex tasks |
| `backend-architect.md` | backend-architect | Sonnet | API, database, service layer |
| `frontend-architect.md` | frontend-architect | Sonnet | UI components, state, accessibility |
| `security-auditor.md` | security-auditor | Sonnet | OWASP, auth/authz, secrets |
| `test-engineer.md` | test-engineer | Sonnet | Tests, coverage, automation |
| `devops-engineer.md` | devops-engineer | Sonnet | CI/CD, containers, infrastructure |
| `code-reviewer.md` | code-reviewer | Sonnet | Quality, standards, pre-merge |
| `performance-analyst.md` | performance-analyst | Sonnet | Query optimization, bundle analysis |

## After Installation

Agents reference `.claude/rules/` files. For best results, also install the **rules module** and customize the rule files for your project.

## Customizing Agents

Each agent file is a standalone markdown file with YAML frontmatter. Edit the system prompt to:
- Reference your specific framework or libraries
- Add project-specific constraints or patterns
- Adjust which rules files to read

See `templates/agents/agent-template.md` for the full agent authoring guide.
