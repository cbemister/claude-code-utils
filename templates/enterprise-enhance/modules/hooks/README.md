# Hooks Module

Pre-configured Claude Code hooks for safety, automation, and auditability. Add to your `.claude/settings.json`.

## How to Merge

Your `settings.json` may already have hooks. **Merge, don't overwrite.** Add the hook entries from each JSON file into the matching array in your existing `settings.json`.

```json
// Existing settings.json
{
  "hooks": {
    "PreToolUse": [
      // ADD new PreToolUse hooks here
    ],
    "PostToolUse": [
      // ADD new PostToolUse hooks here
    ]
  }
}
```

## Available Hooks

| File | Trigger | What it does |
|---|---|---|
| `security-scan.json` | PreToolUse on Edit/Write | Scans for hardcoded secrets before saving |
| `auto-format.json` | PostToolUse on Edit/Write | Runs Prettier/Black if config present |
| `type-check.json` | PostToolUse on Edit/Write | Runs tsc on TypeScript files |
| `audit-log.json` | PostToolUse on all tools | Appends usage to `.claude/audit.log` |

## Recommended Combination

For a standard enterprise setup, install all four:

```bash
# The /enterprise-enhance skill installs these automatically.
# To install manually, merge each JSON file into .claude/settings.json
```

## Testing Hooks

After installing, test that hooks are active:
- **Security scan:** Add `sk-fakekeyabcdef123456` to a file and save — you should see a warning
- **Auto-format:** Edit a `.ts` file and confirm it formats on save (requires `.prettierrc`)
- **Type-check:** Make a type error in a `.ts` file — you should see the tsc error in the output
- **Audit log:** After any tool use, check that `.claude/audit.log` was updated
