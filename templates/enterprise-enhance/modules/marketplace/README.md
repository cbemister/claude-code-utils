# Marketplace Module

Publish your project's agents and skills as a Claude Code plugin marketplace.

## What is a Plugin Marketplace?

A plugin marketplace is a `marketplace.json` file (hosted on GitHub or another git service) that catalogs Claude Code plugins — agents, skills, commands, hooks, and MCP servers. Other developers add your marketplace with `/plugin marketplace add owner/repo` and can install your plugins with `/plugin install`.

## Setup Steps

1. **Copy `marketplace.json`** to your project root
2. **Customize** the file:
   - Replace `[project-name]` with your project's npm-style name (kebab-case)
   - Fill in `owner.name` and `owner.email`
   - Update the `plugins` array to reference your actual agents/skills
3. **Validate:** `claude plugin validate .`
4. **Commit and push** to GitHub
5. **Share:** Others add your marketplace with `/plugin marketplace add [owner]/[repo]`

## marketplace.json Reference

```json
{
  "name": "your-project-name",
  "owner": { "name": "You", "email": "you@example.com" },
  "plugins": [
    {
      "name": "plugin-name",
      "description": "What this plugin does",
      "version": "1.0.0",
      "author": "You",
      "license": "MIT",
      "category": "agents | commands | hooks | mcpServers",
      "keywords": ["tag1", "tag2"],
      "components": {
        "agents": [
          { "source": "./.claude/agents/my-agent.md" }
        ],
        "commands": [
          { "source": "./.claude/commands/my-command.md" }
        ]
      }
    }
  ]
}
```

## Source Types

Plugins can reference files from multiple locations:

```json
// Local file (relative path)
{ "source": "./.claude/agents/my-agent.md" }

// GitHub repository
{ "source": "github:owner/repo/path/to/agent.md", "ref": "main" }

// npm package
{ "source": "npm:package-name", "version": "^1.0.0" }

// Git subdirectory (sparse clone)
{ "source": "git:https://github.com/owner/repo", "subdirectory": "agents/" }
```

## Team Marketplace Configuration

To require your marketplace across a team, add to `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [
    { "url": "https://github.com/[owner]/[repo]", "name": "[project-name]" }
  ],
  "enabledPlugins": ["enterprise-agent-team"]
}
```

## Validation

Always validate before sharing:

```bash
claude plugin validate .
# or
/plugin validate .
```

## Version Management

Use git tags to manage release channels:

```bash
# Tag a stable release
git tag v1.0.0
git push origin v1.0.0

# Users pin to stable: { "ref": "v1.0.0" }
# Users track latest: { "ref": "main" }
```
