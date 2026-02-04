# Claude Code Shared Resources

## Overview
This repository contains shareable Claude Code resources including sub-agents, skills, commands, templates, and documentation.

## Project Structure
```
.claude/
├── agents/           # Sub-agents by purpose (explore, plan, implement)
├── commands/         # Slash commands (git, plan, project)
└── skills/           # Workflow automations

plans/                # Plan system and templates
templates/            # Reusable templates (CLAUDE.md, skills, agents)
docs/                 # Documentation and best practices
scripts/              # Installation scripts
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
Skills are Markdown files that define workflows:
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
1. Create file in `.claude/skills/<name>.md`
2. Add YAML frontmatter
3. Write instructions in markdown
4. Update skills README
