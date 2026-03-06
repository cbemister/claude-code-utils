<!-- PASTE THIS SECTION INTO YOUR CLAUDE.md AFTER YOUR KEY COMMANDS SECTION -->

## Agent Team

This project uses a specialized enterprise agent team. Agents read `.claude/rules/` to understand the codebase before making decisions.

| Agent | When to Use |
|---|---|
| `coordinator` | Complex multi-layer tasks, parallel work coordination |
| `backend-architect` | APIs, database changes, service layer |
| `frontend-architect` | UI components, pages, state management |
| `security-auditor` | Before merging any auth/permission changes |
| `test-engineer` | Adding test coverage, TDD setup |
| `devops-engineer` | CI/CD, deployment, infrastructure |
| `code-reviewer` | Pre-merge review, quality checks |
| `performance-analyst` | Slow queries, bundle analysis, scaling |

### Recommended Workflows

**New feature:**
```
coordinator → backend-architect + frontend-architect → security-auditor → test-engineer → code-reviewer
```

**Bug fix:**
```
debugger → [backend/frontend]-architect → test-engineer (regression)
```

**Pre-launch:**
```
security-auditor + performance-analyst (parallel) → code-reviewer
```
