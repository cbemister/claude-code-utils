---
name: evolution-gate
description: Use when an optimization has been built and needs preview deployment then human decision. Deploys preview, then approves (merge to production) or rejects (discard and retry).
argument-hint: "deploy | approve | reject [reason]"
---

# Evolution Gate

Two-step gate for evolution cycles: first deploy a preview for review, then approve or reject.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Parse the command argument and execute. Never ask follow-up questions. If argument is missing or invalid, display usage and stop.

---

### Step 0: Parse Command

Read `$ARGS`:

- **`deploy`** → Run Pre-Deploy Flow (create preview branch, push, notify)
- **`approve`** → Run Approve Flow
- **`reject [reason]`** → Run Reject Flow
- **No argument or invalid** → Display usage:
  ```
  Usage:
    /evolution-gate deploy           — create preview branch and push for review
    /evolution-gate approve          — merge preview to production
    /evolution-gate reject [reason]  — discard preview and retry

  Current Status:
    [read and display evolution-state.json status]
  ```

---

### Pre-Deploy Flow

Runs when `$ARGS` is `deploy`. Creates a preview branch and pushes to trigger auto-deploy.

#### D1: Initialize

1. Read `factory/evolution-state.json`
2. Verify status is `"building"` or build is complete (all tasks done)
3. Set `CYCLE` to `current_cycle`, read `deploy_target`, get hypothesis info from `cycles[]`

#### D2: Pre-Flight Verification

Run quality checks — if blocking issues found, update status to `"building"`, display issues, stop.

**Security & quality** (from verify-work rubric):
- Hardcoded secrets, SQL injection, XSS, missing input validation
- Debug code, TypeScript `any`, empty catch blocks

**Performance** (from verify-performance rubric):
- N+1 queries, unbounded queries, data fetching in loops

**Build check:**
```bash
npm run build 2>&1 || yarn build 2>&1 || pnpm build 2>&1
```

#### D3: Create Preview Branch

```bash
git checkout -b preview/evolution-cycle-{CYCLE}-{slug}
git add -A
git commit -m "feat: evolution cycle {CYCLE} — {hypothesis titles}

Hypotheses:
- {hyp-id-1}: {title-1}
- {hyp-id-2}: {title-2}

Predicted score change: {baseline} → {predicted} (+{delta})
Stage plan: {stage_plan_ref}
"
git push -u origin preview/evolution-cycle-{CYCLE}-{slug}
```

Where `{slug}` is a kebab-case summary of the primary hypothesis (max 30 chars).

#### D4: Update State

Update `factory/evolution-state.json`:
- Status: `"preview_deployed"`
- Current cycle: `preview_branch`, `preview_url` (based on Vercel/Netlify pattern from `deploy_target.platform`)

#### D5: Slack Notification (if configured)

Send using temp file pattern:
```bash
TMPFILE=$(mktemp)
cat > "$TMPFILE" << 'PAYLOAD'
{"text": "🔍 Preview Ready — Cycle {CYCLE}", "blocks": [{"type": "section", "text": {"type": "mrkdwn", "text": "*Preview Deployed* — Cycle {CYCLE}\n\n*Hypotheses:*\n• {title-1}\n• {title-2}\n\n*Preview:* {preview_url}\n\n*Actions:*\n`/evolution-gate approve` or `/evolution-gate reject`"}}]}
PAYLOAD
curl -s -X POST -H 'Content-type: application/json' -d @"$TMPFILE" "$SLACK_WEBHOOK"
rm -f "$TMPFILE"
```

#### D6: Switch Back & Display

```bash
git checkout {production_branch}
```

```
================================================================
  Preview Deployed — Awaiting Human Approval
================================================================
  Cycle:    {CYCLE}
  Branch:   preview/evolution-cycle-{CYCLE}-{slug}
  Preview:  {preview_url}

  Pre-Flight:  verify-work PASS | verify-performance PASS | build PASS

  Actions:
    /evolution-gate approve   — merge to production
    /evolution-gate reject    — discard and try next
================================================================
```

---

### Approve Flow

Runs when `$ARGS` is `approve`.

- **`approve`** → Step 1 (Approve Flow)
- **`reject [reason]`** → Step 2 (Reject Flow)
- **No argument or invalid** → Display usage and stop:
  ```
  Usage:
    /evolution-gate approve           — merge preview to production
    /evolution-gate reject [reason]   — discard preview and retry

  Current Status:
    [read and display evolution-state.json status]
  ```

---

### Step 1: Approve Flow

#### 1A: Validate State

1. Read `factory/evolution-state.json`
2. Verify status is `"preview_deployed"` or `"awaiting_approval"`
   - If not, display error: "No preview awaiting approval. Current status: [status]"
3. Get current cycle entry from `cycles[]`
4. Get `preview_branch` and `production_branch` from state

#### 1B: Merge to Production

```bash
# Switch to production branch
git checkout {production_branch}

# Merge the preview branch
git merge preview/evolution-cycle-{CYCLE}-{slug} --no-ff -m "feat: merge evolution cycle {CYCLE} — {hypothesis titles}

Approved optimization cycle {CYCLE}.
Hypotheses: {hypothesis titles}
Predicted score improvement: +{delta}
"
```

#### 1C: Tag Release

```bash
git tag -a "evolution-cycle-{CYCLE}" -m "Evolution cycle {CYCLE}: {hypothesis titles}"
```

#### 1D: Clean Up Preview Branch

```bash
# Delete local preview branch
git branch -d preview/evolution-cycle-{CYCLE}-{slug}

# Delete remote preview branch
git push origin --delete preview/evolution-cycle-{CYCLE}-{slug}
```

#### 1E: Archive Stage Plan

```bash
mkdir -p plans/archive
mv plans/active/stage-opt-{CYCLE}.md plans/archive/stage-opt-{CYCLE}.md
```

#### 1F: Update Evolution State

1. Read `factory/evolution-state.json`
2. Update status to `"idle"` (ready for next evaluation)
3. Update current cycle entry:
   ```json
   {
     "status": "approved",
     "score_delta": null
   }
   ```
   (Score delta will be filled by next `/evaluate-product` run)
4. Increment `current_cycle` by 1
5. Increment `total_cycles_completed` by 1
6. Write back

#### 1G: Push to Remote

```bash
git push origin {production_branch}
git push origin --tags
```

#### 1H: Send Slack Notification (if configured)

```bash
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"
```

If available:
```bash
TMPFILE=$(mktemp)
cat > "$TMPFILE" << 'PAYLOAD'
{
  "text": "✅ Evolution Cycle {CYCLE} Approved",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Cycle {CYCLE} Merged to Production*\n\n*Hypotheses:*\n• {title-1}\n• {title-2}\n\nTagged: `evolution-cycle-{CYCLE}`\nNext: Re-run `/factory evolve` to start next cycle"
      }
    }
  ]
}
PAYLOAD
curl -s -X POST -H 'Content-type: application/json' -d @"$TMPFILE" "$SLACK_WEBHOOK"
rm -f "$TMPFILE"
```

#### 1I: Display Summary

```
================================================================
  Evolution Cycle [CYCLE] — Approved
================================================================

  Merged:      preview/evolution-cycle-{CYCLE}-{slug} → {production_branch}
  Tag:         evolution-cycle-{CYCLE}
  Plan:        Archived to plans/archive/stage-opt-{CYCLE}.md

  Hypotheses Applied:
    - [title 1]
    - [title 2]

  Next: Run /factory evolve to evaluate and start next cycle
================================================================
```

---

### Step 2: Reject Flow

#### 2A: Validate State

1. Read `factory/evolution-state.json`
2. Verify status is `"preview_deployed"` or `"awaiting_approval"`
   - If not, display error: "No preview awaiting approval. Current status: [status]"
3. Get current cycle entry from `cycles[]`
4. Get `preview_branch` from state
5. Parse rejection reason from `$ARGS` (everything after "reject")
   - If no reason provided, use `"Rejected without reason"`

#### 2B: Delete Preview Branch

```bash
# Switch to production branch
git checkout {production_branch}

# Delete local preview branch
git branch -D preview/evolution-cycle-{CYCLE}-{slug}

# Delete remote preview branch
git push origin --delete preview/evolution-cycle-{CYCLE}-{slug}
```

#### 2C: Archive Stage Plan

```bash
mkdir -p plans/archive
mv plans/active/stage-opt-{CYCLE}.md plans/archive/stage-opt-{CYCLE}.md
```

#### 2D: Update Evolution State

1. Read `factory/evolution-state.json`
2. Update status to `"hypothesizing"` (signals: generate new hypotheses)
3. Update current cycle entry:
   ```json
   {
     "status": "rejected",
     "rejection_reason": "[reason]"
   }
   ```
4. Add rejected hypotheses to `rejected_hypotheses[]`:
   ```json
   {
     "id": "hyp-{CYCLE}-001",
     "title": "[title]",
     "reason": "[rejection reason]",
     "cycle": [CYCLE]
   }
   ```
   (Add one entry per hypothesis in the rejected batch)
5. Increment `current_cycle` by 1 (move to next cycle for retry)
6. Write back

#### 2E: Send Slack Notification (if configured)

If `SLACK_WEBHOOK` is available:

```bash
TMPFILE=$(mktemp)
cat > "$TMPFILE" << 'PAYLOAD'
{
  "text": "❌ Evolution Cycle {CYCLE} Rejected",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Cycle {CYCLE} Rejected*\n\n*Reason:* {reason}\n\n*Rejected Hypotheses:*\n• {title-1}\n• {title-2}\n\nNext: Re-run `/factory evolve` to generate new hypotheses"
      }
    }
  ]
}
PAYLOAD
curl -s -X POST -H 'Content-type: application/json' -d @"$TMPFILE" "$SLACK_WEBHOOK"
rm -f "$TMPFILE"
```

#### 2F: Display Summary

```
================================================================
  Evolution Cycle [CYCLE] — Rejected
================================================================

  Reason:      [rejection reason]
  Branch:      Deleted preview/evolution-cycle-{CYCLE}-{slug}
  Plan:        Archived to plans/archive/stage-opt-{CYCLE}.md

  Rejected Hypotheses (will not be retried):
    - [title 1]
    - [title 2]

  Next: Run /factory evolve to generate new hypotheses
================================================================
```

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| Merge conflict on approve | Display conflict details, suggest manual resolution |
| Preview branch doesn't exist locally | Fetch and checkout: `git fetch origin && git checkout preview/...` |
| Preview branch doesn't exist remotely | Skip remote delete, continue with local operations |
| Remote push fails | Display error, note that local merge succeeded, suggest manual push |
| Stage plan already archived | Skip archive step |
| No preview awaiting approval | Display current status and available actions |
