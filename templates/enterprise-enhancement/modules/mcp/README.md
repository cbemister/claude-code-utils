# MCP Module

Model Context Protocol server configurations for common enterprise integrations.

## How to Install

1. Copy the desired server config(s) from the JSON files below
2. Merge into your project's `.mcp.json` under `mcpServers`
3. Set the required environment variables (see `.claude/rules/env.md`)
4. Restart Claude Code

```json
// .mcp.json
{
  "mcpServers": {
    // Paste server configs here
  }
}
```

## Available Servers

| File | Server | Provides | Env Vars Required |
|---|---|---|---|
| `github.json` | GitHub | Repo search, PR management, issue tracking | `GITHUB_TOKEN` |
| `postgres.json` | PostgreSQL | Database queries, schema inspection | `DATABASE_URL` |
| `slack.json` | Slack | Channel messaging, history | `SLACK_BOT_TOKEN`, `SLACK_TEAM_ID` |
| `filesystem.json` | Filesystem | File operations outside project root | None (update path) |

## Finding More MCP Servers

- Official servers: https://github.com/modelcontextprotocol/servers
- Community registry: Search npm for `@modelcontextprotocol/server-*`
- Build your own: See Claude Code MCP documentation

## Security Notes

- Never hardcode credentials in `.mcp.json` — always use `${ENV_VAR}` references
- MCP servers run as subprocesses with access to your environment — only install trusted servers
- Review what tools each MCP server exposes before enabling it in production workflows
