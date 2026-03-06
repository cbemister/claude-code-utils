# Installing Rules

The enterprise rules template files live in the greenfield starter template to avoid duplication.

## Option 1: Use the /enterprise-enhance skill (recommended)

```
/enterprise-enhance
```

Select "rules" when prompted. The skill copies and places the files automatically.

## Option 2: Copy from the starter template

```bash
# From the claude-code-utils repository root:
mkdir -p .claude/rules
cp templates/enterprise-starter/.claude/rules/*.md .claude/rules/
```

## After Installing

**Customize every file** — replace all `[PLACEHOLDER]` values with your actual project details.

Rules only help agents if they reflect reality. An uncustomized rules file is worse than no rules file because it provides wrong information.

Priority order for customization:
1. `architecture.md` — agents need this most
2. `env.md` — update before running any hooks
3. `security-policy.md` — critical for security-auditor
4. `api-conventions.md` — needed before backend-architect generates endpoints
5. `code-standards.md` — needed before code-reviewer reviews
6. `testing-standards.md` — needed before test-engineer writes tests
