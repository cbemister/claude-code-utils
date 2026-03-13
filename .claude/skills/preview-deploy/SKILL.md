---
name: preview-deploy
description: Use when an optimization has been built and needs a preview deployment for human review. Creates a preview branch, runs pre-flight checks, pushes to trigger auto-deploy on Vercel/Netlify.
---

# Preview Deploy

Create a preview branch and push to remote to trigger auto-deploy on Vercel/Netlify. Runs pre-flight verification before pushing.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Execute all steps without pausing. Never ask questions, request confirmation, or wait for input. Read state, verify, branch, push, update state, stop.

---

### Step 0: Initialize

1. Read `factory/evolution-state.json`:
   - Verify status is `"building"` or check that the build has completed (build-state.json shows all tasks done)
   - Set `CYCLE` to `current_cycle`
   - Read `deploy_target` for platform info

2. Read the current cycle entry from `cycles[]` to get:
   - `hypothesis_ids` and `hypothesis_titles`
   - `stage_plan_ref`

---

### Step 1: Pre-Flight Verification

Run quality checks before creating the preview:

#### 1A: Verify Work

Apply `/verify-work` rubric — check for:
- Security vulnerabilities
- Lint/type errors
- Missing error handling
- Hardcoded secrets

If **blocking issues** found: update status to `"building"` (needs fixes), display issues, stop.

#### 1B: Verify Performance

Apply `/verify-performance` rubric — check for:
- N+1 queries
- Unbounded loops
- Missing loading states
- Unoptimized images

If **blocking issues** found: update status to `"building"` (needs fixes), display issues, stop.

#### 1C: Build Check

Run the project's build command (from CLAUDE.md or package.json):

```bash
npm run build 2>&1 || yarn build 2>&1 || pnpm build 2>&1
```

If build fails: update status to `"building"`, display error, stop.

---

### Step 2: Create Preview Branch

1. Generate branch name:
   ```
   preview/evolution-cycle-{CYCLE}-{slug}
   ```
   Where `{slug}` is a kebab-case summary of the primary hypothesis (max 30 chars).

2. Create and switch to the branch:
   ```bash
   git checkout -b preview/evolution-cycle-{CYCLE}-{slug}
   ```

3. Stage all changes:
   ```bash
   git add -A
   ```

4. Commit with evolution metadata:
   ```bash
   git commit -m "feat: evolution cycle {CYCLE} — {hypothesis titles}

   Hypotheses:
   - {hyp-id-1}: {title-1}
   - {hyp-id-2}: {title-2}

   Predicted score change: {baseline} → {predicted} (+{delta})
   Stage plan: {stage_plan_ref}
   "
   ```

---

### Step 3: Push to Remote

Push the preview branch to trigger auto-deploy:

```bash
git push -u origin preview/evolution-cycle-{CYCLE}-{slug}
```

---

### Step 4: Determine Preview URL

Based on `deploy_target.platform`:

| Platform | Expected Preview URL Pattern |
|----------|------------------------------|
| Vercel | `https://{project}-{branch-slug}.vercel.app` |
| Netlify | `https://{branch-slug}--{project}.netlify.app` |
| Other | `[branch pushed — check deploy platform for preview URL]` |

Note: The actual URL depends on the platform's project configuration. The URL above is the expected pattern.

---

### Step 5: Update Evolution State

1. Read `factory/evolution-state.json`
2. Update status to `"preview_deployed"`
3. Update the current cycle entry:
   ```json
   {
     "preview_branch": "preview/evolution-cycle-{CYCLE}-{slug}",
     "preview_url": "[expected URL]"
   }
   ```
4. Write back

---

### Step 6: Send Slack Notification (if configured)

Check for Slack webhook in environment or config:

```bash
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"
```

If available, send notification using temp file pattern (Windows Git Bash compatible):

```bash
TMPFILE=$(mktemp)
cat > "$TMPFILE" << 'PAYLOAD'
{
  "text": "🔍 Preview Ready — Evolution Cycle {CYCLE}",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Preview Deployed* — Cycle {CYCLE}\n\n*Hypotheses:*\n• {title-1}\n• {title-2}\n\n*Preview:* {preview_url}\n\n*Actions:*\n`/evolution-gate approve` — merge to production\n`/evolution-gate reject` — discard and retry"
      }
    }
  ]
}
PAYLOAD
curl -s -X POST -H 'Content-type: application/json' -d @"$TMPFILE" "$SLACK_WEBHOOK"
rm -f "$TMPFILE"
```

---

### Step 7: Switch Back to Production Branch

```bash
git checkout {production_branch}
```

Where `{production_branch}` comes from `deploy_target.production_branch` (default: `main`).

---

### Step 8: Display Summary

```
================================================================
  Preview Deployed — Awaiting Human Approval
================================================================

  Project:     [name]
  Cycle:       [CYCLE]
  Branch:      preview/evolution-cycle-{CYCLE}-{slug}
  Preview:     [expected preview URL]

  Hypotheses in this cycle:
    - [hypothesis title 1]
    - [hypothesis title 2]

  Pre-Flight Results:
    Verify Work:        PASS
    Verify Performance: PASS
    Build:              PASS

  Actions:
    /evolution-gate approve    — merge to production
    /evolution-gate reject     — discard and try next

================================================================
```

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| Pre-flight fails | Stay in `"building"` status, display issues for /build-app to fix |
| Branch already exists | Delete old branch first: `git branch -D preview/...` then recreate |
| Push fails (auth) | Display error with instructions to configure git credentials |
| Push fails (network) | Retry once, then display error |
| No remote configured | Display error: "No git remote configured. Push manually." |
| Build command unknown | Try npm, yarn, pnpm in order; if all fail, skip build check with warning |
