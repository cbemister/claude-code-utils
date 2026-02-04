# Claude Code Shared Resources

## Overview
This repository contains shareable Claude Code resources including sub-agents, skills, commands, templates, and documentation.

## Project Structure
```
.claude/
├── agents/           # Sub-agents by purpose (explore, plan, implement)
├── commands/         # Slash commands (git, plan, project)
└── skills/           # Project-local skills (work immediately!)

plans/                # Plan system and templates
templates/            # Reusable templates (CLAUDE.md, skills, agents)
docs/                 # Documentation and best practices
scripts/              # Install scripts (copy skills to ~/.claude/skills/ for personal use)
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
---
```

### Model Selection
- **Haiku**: Fast, cheap - use for exploration and simple tasks
- **Sonnet**: Balanced - use for implementation and reviews
- **Opus**: Powerful - use for architecture and complex planning

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
---
```

## Development Commands
```bash
# No build required - this is a resource repository
# Test by copying to a project and using the agents/skills
```

## Adding New Resources

### New Agent
1. Create file in `.claude/agents/<category>/<name>.md`
2. Add YAML frontmatter with name, description, tools, model
3. Write system prompt in markdown body
4. Update agents README

### New Skill
1. Create directory `.claude/skills/<name>/`
2. Create `SKILL.md` file inside
3. Add YAML frontmatter with name and description
4. Write instructions in markdown
5. Restart Claude Code to test
6. Update [.claude/skills/README.md](.claude/skills/README.md)
