<!-- PASTE THIS SECTION INTO YOUR CLAUDE.md — NEAR THE END, BEFORE ANY NOTES -->

## Enterprise Standards

### Code Quality

- All PRs require passing CI (lint + type check + tests)
- All PRs require at least 1 approval from a team member
- Coverage must not drop below the target in `.claude/rules/testing-standards.md`
- No `any` types without explicit justification

### Security Requirements

- `security-auditor` agent review required before merging any auth or permission changes
- All API endpoints must validate input at the boundary
- No secrets in source code — use environment variables only
- See `.claude/rules/security-policy.md` for the full policy

### Review Requirements

- New API endpoints: `backend-architect` review of contract + `code-reviewer` pre-merge
- New UI flows: `frontend-architect` accessibility check + `code-reviewer` pre-merge
- Performance-sensitive paths: `performance-analyst` review before shipping

### Deployment Standards

- Never deploy directly to production — use staging first
- Database migrations run before code deploys
- All deployments require passing tests in CI
- Roll back immediately if error rate spikes post-deploy

### Hooks

`.claude/settings.json` enforces:
- Secret scan on every file save
- Auto-format on save (Prettier/Black)
- TypeScript type check on `.ts`/`.tsx` edits
- Blocked patterns: `rm -rf`, `curl | bash`, force push
