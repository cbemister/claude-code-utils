---
name: evolution-gate
description: Use when a preview deployment is ready for human decision. Approves (merge to production) or rejects (discard and retry with next hypotheses).
args: "approve|reject [reason] - Required: approve to merge, reject to discard"
---

# Evolution Gate

Human approval/rejection gate for evolution cycle previews. Merges approved optimizations to production or discards rejected ones and prepares for the next attempt.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Parse the command argument and execute. Never ask follow-up questions. If argument is missing or invalid, display usage and stop.

---

### Step 0: Parse Command

Read `$ARGS`:

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
