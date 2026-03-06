# Installing Agent Teams

The enterprise agent files live in the greenfield starter template to avoid duplication.

## Option 1: Use the /enterprise-enhance skill (recommended)

```
/enterprise-enhance
```

Select "agent-teams" when prompted. The skill copies files from the starter template automatically.

## Option 2: Copy from the starter template

```bash
# From the claude-code-utils repository root:
cp templates/enterprise-starter/.claude/agents/*.md /your/project/.claude/agents/

# Or if you installed globally:
cp ~/.claude/skills/enterprise-starter/templates/.claude/agents/*.md .claude/agents/
```

## Option 3: Install from the marketplace

If the starter has been published to a GitHub marketplace:

```
/plugin marketplace add [owner]/[repo]
/plugin install enterprise-agent-team
```

## After Installing

1. Restart Claude Code
2. Also install the **rules module** — agents reference `.claude/rules/` files
3. Customize rule files for your project before using agents
