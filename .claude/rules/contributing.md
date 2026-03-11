# Contributing

## Adding a New Agent

1. Create markdown file: `templates/enhance-app/.claude/agents/<name>.md`
2. Include YAML frontmatter: `name`, `description`, `tools`, `model`, optional `skills`
3. Write system prompt in markdown body
4. Add to relevant teams in `templates/enhance-app/teams/teams.json`
5. Update coordinator for affected teams in `teams/<team>/coordinator.md`
6. Update `templates/enhance-app/.claude/agents/README.md`
7. Update `.claude/rules/agent-teams.md` in this project

## Adding a New Skill

1. Create directory: `.claude/skills/<name>/`
2. Create `SKILL.md` with YAML frontmatter (`name`, `description`, optional `args`)
3. Write instructions in markdown
4. Update `.claude/skills/README.md`
5. Update `.claude/rules/skills-catalog.md` in this project
6. Restart Claude Code to test

## Adding a New Plan Template

1. Create file: `plans/templates/<name>.md`
2. Include YAML frontmatter with type-specific metadata
3. Update `plans/templates/README.md`
4. Update `.claude/rules/templates.md` in this project

## Adding a New Team Preset

1. Add team entry in `templates/enhance-app/teams/teams.json`
2. Create `templates/enhance-app/teams/<team>/coordinator.md`
3. Update `templates/enhance-app/teams/README.md`
4. Update `.claude/rules/agent-teams.md` in this project

## Commit Conventions

- `feat` — New agent, skill, template, or team
- `fix` — Bug fix in existing resource
- `docs` — Documentation updates
- `refactor` — Restructuring without behavior change

## Content Standards

- All content is markdown (no compiled code)
- Use YAML frontmatter for metadata
- Templates use `[PLACEHOLDER]` syntax for values filled at install time
- Rule files in `templates/enhance-app/` use `> [CUSTOMIZE THIS FILE]` callout
- Windows Git Bash compatible (forward slashes, no Windows-specific commands)
