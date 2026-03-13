---
name: build-app
description: Autonomously build an app from staged plans created by /launch-app. Reads plans/active/ stage files and builds each stage with verification, commits, and Slack notifications. Designed for unattended execution via build-app-runner.sh.
args: "[command] - Optional: 'status' to show progress, 'resume' to continue after failure, 'reset' to clear state"
---

# Build App

Autonomously build an app from staged plans. Picks up where `/launch-app` leaves off — reads stage plans from `plans/active/`, executes tasks in dependency order, runs verification, commits each task, and tracks progress in `plans/build-state.json`.

Designed for unattended execution. The companion `build-app-runner.sh` script re-invokes this skill across context windows until all stages are complete.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Execute all phases without pausing. Never ask questions, request confirmation, or wait for input. Read state, build, verify, commit, update state, repeat. If something fails, fix it or mark it failed and move on.

---

### Step 0: Parse Arguments

Check if a command argument was provided:

- **`status`**: Read `plans/build-state.json`, display a formatted progress summary, then **stop**.
- **`resume`**: Read `plans/build-state.json`, clear "failed" status on the current stage (set it back to "in_progress"), reset retry counter, then continue to Step 1.
- **`reset`**: Delete `plans/build-state.json` if it exists, confirm deletion, then **stop**.
- **No argument / anything else**: Continue to Step 1 (normal build).

---

### Step 1: Initialize State

#### 1A: Check for Existing State

Read `plans/build-state.json`. If it exists and `status` is `"complete"`, report completion and **stop**.

If it exists and `status` is `"failed"`, report the failure details and **stop** (user should run `/build-app resume` to continue).

If it exists and `status` is `"in_progress"`, skip to Step 2 (resume building).

#### 1B: Bootstrap State (First Run)

If `plans/build-state.json` does not exist:

1. Scan `plans/active/` for files matching `stage-*.md`
2. Sort by stage number (extract N from `stage-N-...`)
3. Read the project name from `CLAUDE.md` (first heading or project description)
4. Read team info from `CLAUDE.md` (Agent Team section)
5. Create `plans/build-state.json`:

```json
{
  "version": 1,
  "project": "[project-name]",
  "team": "[team-preset]",
  "status": "in_progress",
  "current_stage": 0,
  "total_stages": N,
  "iteration_count": 0,
  "started_at": "[ISO timestamp]",
  "updated_at": "[ISO timestamp]",
  "stages": [
    {
      "stage": 0,
      "title": "[from stage plan frontmatter]",
      "file": "plans/active/stage-0-[title].md",
      "status": "pending",
      "started_at": null,
      "completed_at": null,
      "tasks": {},
      "verification": {},
      "retries": 0,
      "error": null,
      "preview_url": null
    }
  ]
}
```

6. Send Slack notification: build started

---

### Step 2: Find Next Stage

1. Read `plans/build-state.json`
2. Increment `iteration_count`
3. Find the first stage where `status` is not `"complete"`
4. If no such stage exists → mark build `"complete"`, send Slack notification, **stop** (exit 0)
5. Set `current_stage` to that stage's number
6. Update `plans/build-state.json`

---

### Step 3: Prepare Stage

If the current stage's status is `"pending"`:

1. **Refresh the plan** — Invoke `/plan-next-stage [stage-file]` to update the stage plan against the actual codebase state. This ensures file paths, imports, and interfaces match what prior stages actually built.

2. **Mark stage as in_progress** — Update the stage entry in `plans/build-state.json`:
   ```json
   {
     "status": "in_progress",
     "started_at": "[ISO timestamp]"
   }
   ```

3. **Send Slack notification** — Stage starting (use temp file to avoid Windows Git Bash quote issues):
   ```bash
   if [ -n "$SLACK_WEBHOOK_URL" ]; then
     tmpfile=$(mktemp)
     cat > "$tmpfile" <<EOFSLACK
   {"text":"Building *[project]*: Stage [N]: [Title] starting ([M] tasks)"}
   EOFSLACK
     curl -s -X POST "$SLACK_WEBHOOK_URL" \
       -H "Content-type: application/json" \
       --data-binary @"$tmpfile" 2>/dev/null || true
     rm -f "$tmpfile"
   fi
   ```

If the stage is already `"in_progress"` (resuming), skip the refresh and notification — just continue from the next incomplete task.

---

### Step 4: Execute Tasks

Read the stage plan file to get the task list. Parse the task sections (Task NA, NB, NC, etc.).

#### 4A: Determine Task Order

Read the **Parallelization** section of the stage plan to understand dependencies:
- Tasks marked as parallel can be executed in any order (but sequentially — true parallelism not supported)
- Tasks with dependencies must wait for their dependencies to complete

Build an ordered list of tasks respecting dependencies.

#### 4B: Skip Completed Tasks

Check `plans/build-state.json` for tasks already marked `"complete"` in this stage. Skip those.

Also cross-reference with git history — if a task's expected commit message exists in `git log --oneline`, mark it as complete in state even if state says otherwise (drift correction).

#### 4C: Execute Each Task

For each pending task in order:

1. **Read the task section** from the stage plan — get Steps, Files, and Verify sections
2. **Execute the steps** — Follow the numbered steps exactly as written in the plan. This means:
   - Create files listed as **new**
   - Modify files listed as **modify** or **extend**
   - Run any setup commands specified in the steps
   - Write the actual implementation code following the code snippets and interfaces in the plan
3. **Run Tier 1 verification** (Compiles):
   - Execute the Tier 1 command from the task's Verify section
   - If it fails: fix the error and retry (up to 3 attempts)
4. **Run Tier 2 verification** (Unit/Integration) if specified:
   - Execute the Tier 2 command
   - If it fails: fix the failing tests and retry (up to 3 attempts)
5. **Commit the task**:
   ```bash
   git add -A
   git commit -m "$(cat <<'EOF'
   [commit message from stage plan's Commits section]

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```
6. **Update state** — Mark the task complete in `plans/build-state.json`:
   ```json
   {
     "status": "complete",
     "commit": "[short hash from git log -1 --format=%h]"
   }
   ```
7. **Write state to disk immediately** — Do not batch state updates

#### 4D: Handle Task Failures

If a task fails verification after 3 retry attempts:

1. Record the error in the task state:
   ```json
   { "status": "failed", "error": "[error description]" }
   ```
2. Increment the stage's `retries` counter
3. If `retries >= 3`:
   - Mark the stage as `"failed"` with error details
   - Send Slack notification: stage failed
   - Update `plans/build-state.json`
   - **Stop** (exit 1)
4. If `retries < 3`:
   - Log the failure, attempt to fix the underlying issue
   - Retry the task from scratch

---

### Step 5: Complete Stage

After all tasks in the stage are complete:

#### 5A: Stage Checkpoint Verification

Read the **Stage Checkpoint: Success Criteria** section from the stage plan. Run each criterion:

- Execute the verification commands listed in the checkpoint table
- Check each threshold against actual results
- If any criterion fails: attempt to fix, retry once. If still failing, mark stage failed.

#### 5B: Quality Gate

Run `/verify-work` to check for security vulnerabilities, code quality issues, and convention adherence. Auto-fix what can be fixed, commit fixes.

#### 5C: Finalize Stage

1. Update stage status in `plans/build-state.json`:
   ```json
   {
     "status": "complete",
     "completed_at": "[ISO timestamp]",
     "verification": {
       "tier1": true,
       "tier2": true,
       "checkpoint": true
     }
   }
   ```

2. Move the stage plan to archive:
   ```bash
   mkdir -p plans/archive
   mv "plans/active/[stage-file].md" "plans/archive/[stage-file].md"
   ```

3. Update the stage plan frontmatter:
   ```yaml
   status: completed
   completed: [YYYY-MM-DD]
   ```

4. **Deploy preview** (if Netlify CLI is available):
   ```bash
   if command -v netlify &> /dev/null; then
     # Deploy a draft/preview build
     DEPLOY_OUTPUT=$(netlify deploy --dir=. --message="Stage [N]: [Title] complete" 2>&1)
     PREVIEW_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[^ ]*\.netlify\.app' | head -1)

     # Update state with preview URL
     # Add "preview_url": "$PREVIEW_URL" to the stage entry in build-state.json

     # If this is the final stage, deploy to production
     if [[ no more stages remain ]]; then
       netlify deploy --prod --dir=. --message="Build complete: [project]"
       PROD_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[^ ]*\.netlify\.app' | head -1)
     fi
   fi
   ```

   **Note:** The deploy directory should match the project's build output (e.g., `.next`, `dist`, `build`, `out`). Read the project's framework config to determine the correct directory. Run the build command first if needed (e.g., `npm run build`).

5. Send Slack notification: stage complete with preview URL (use temp file pattern as shown in Step 3)
   - Include the preview URL in the message if a deploy was made:
     `"Stage [N]: [Title] complete — Preview: [PREVIEW_URL]"`

---

### Step 6: Continue or Exit

After completing a stage:

1. Check if more stages remain (any stage with status != "complete")
2. If **no more stages**:
   - Mark build as `"complete"` in `plans/build-state.json`
   - Send Slack notification: build complete
   - **Stop** (exit 0)
3. If **more stages remain**:
   - Loop back to Step 2 to start the next stage
   - The runner script will re-invoke this skill if the context window is exhausted mid-stage

---

## Slack Notifications

All Slack notifications are optional — they only fire if `$SLACK_WEBHOOK_URL` is set.

Use this pattern for all notifications (temp file avoids Windows Git Bash quote mangling):

```bash
if [ -n "$SLACK_WEBHOOK_URL" ]; then
  tmpfile=$(mktemp)
  cat > "$tmpfile" <<EOFSLACK
{"text":"[MESSAGE]"}
EOFSLACK
  curl -s -X POST "$SLACK_WEBHOOK_URL" \
    -H "Content-type: application/json" \
    --data-binary @"$tmpfile" 2>/dev/null || true
  rm -f "$tmpfile"
fi
```

| Event | Color | Message |
|-------|-------|---------|
| Build started | `#2196F3` (blue) | "Building *[project]*: [N] stages planned" |
| Stage starting | `#2196F3` (blue) | "Stage [N]: [Title] starting ([M] tasks)" |
| Stage complete | `#36a64f` (green) | "Stage [N]: [Title] complete" |
| Stage failed | `#ff0000` (red) | "Stage [N]: [Title] FAILED — [error]" |
| Stage retrying | `#ff9800` (yellow) | "Stage [N]: Retrying (attempt [M] of 3)" |
| Build complete | `#36a64f` (green) | "Build complete: *[project]* — [N] stages, [M] commits" |
| Build failed | `#ff0000` (red) | "Build FAILED at Stage [N]: [error]" |
| Rate limited | `#9e9e9e` (gray) | "Build paused (rate limit) — will resume" |

---

## State File Reference

The state file lives at `plans/build-state.json`. It is the **single source of truth** for build progress. The runner script reads it between iterations to decide whether to continue, and the skill reads it on startup to know where to resume.

**Key invariants:**
- State is written to disk after every task completion (not batched)
- Git history is used as secondary validation (drift correction on resume)
- The file is committed along with source code changes
- `iteration_count` is incremented once per skill invocation (tracked by runner)

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| Task fails verification | Fix + retry up to 3 times per task |
| Stage fails after max retries | Mark failed, notify Slack, exit 1. User runs `/build-app resume` |
| Context window exhausted | Runner re-invokes; skill reads state and resumes |
| Rate limit hit | Runner detects, waits, re-invokes |
| Git conflict | Resolve conflict, commit, continue |
| Missing dependency | Install it, retry the step |

---

## Usage Examples

### Local (interactive)
```
/build-app              # Start or continue building
/build-app status       # Show progress
/build-app resume       # Resume after failure
/build-app reset        # Clear state and start over
```

### Unattended (via runner script)
```bash
# Run locally, get Slack updates on your phone
./scripts/build-app-runner.sh --slack-webhook $SLACK_WEBHOOK_URL ../my-app

# Run via GitHub Actions (trigger from GitHub UI)
# See .github/workflows/build-app.yml
```

### Full Pipeline
```
1. /launch-app "expense tracker SaaS"    # Creates project with stage plans
2. cd ../expense-tracker
3. /build-app                             # Builds it autonomously
```
