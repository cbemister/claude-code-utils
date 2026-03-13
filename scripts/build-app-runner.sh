#!/bin/bash

# Build App Runner
# Outer loop that re-invokes `claude --print` with the /build-app skill
# until all stages are complete or a fatal error occurs.
#
# Usage: ./scripts/build-app-runner.sh [options] <project-dir>
#
# Options:
#   --max-iterations N        Max loop iterations (default: 50)
#   --budget-per-iter N       Max USD per claude invocation (default: 5)
#   --total-budget N          Max total USD (default: 100)
#   --model MODEL             Model to use (default: sonnet)
#   --slack-webhook URL       Slack webhook URL (or set SLACK_WEBHOOK_URL env var)
#   --skip-permissions        Use --dangerously-skip-permissions (required for unattended)
#   --auto-retry              Auto-retry on rate limits with backoff (default: off)
#   --retry-delay N           Seconds to wait before retrying on rate limit (default: 1800)
#   --dry-run                 Show what would be executed without running
#
# Environment:
#   ANTHROPIC_API_KEY         Required (unless using Claude Code subscription)
#   SLACK_WEBHOOK_URL         Optional: Slack webhook for notifications
#   BUILD_APP_MODEL           Optional: Override model
#   BUILD_APP_MAX_ITERATIONS  Optional: Override max iterations
#   BUILD_APP_BUDGET_PER_ITER Optional: Override per-iteration budget
#   BUILD_APP_TOTAL_BUDGET    Optional: Override total budget

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Defaults
MAX_ITERATIONS="${BUILD_APP_MAX_ITERATIONS:-50}"
BUDGET_PER_ITER="${BUILD_APP_BUDGET_PER_ITER:-5}"
TOTAL_BUDGET="${BUILD_APP_TOTAL_BUDGET:-100}"
MODEL="${BUILD_APP_MODEL:-sonnet}"
SLACK_WEBHOOK="${SLACK_WEBHOOK_URL:-}"
SKIP_PERMISSIONS=false
AUTO_RETRY=false
RETRY_DELAY=1800
DRY_RUN=false
PROJECT_DIR=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --max-iterations) MAX_ITERATIONS="$2"; shift 2 ;;
    --budget-per-iter) BUDGET_PER_ITER="$2"; shift 2 ;;
    --total-budget) TOTAL_BUDGET="$2"; shift 2 ;;
    --model) MODEL="$2"; shift 2 ;;
    --slack-webhook) SLACK_WEBHOOK="$2"; shift 2 ;;
    --skip-permissions) SKIP_PERMISSIONS=true; shift ;;
    --auto-retry) AUTO_RETRY=true; shift ;;
    --retry-delay) RETRY_DELAY="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --help|-h)
      echo "Usage: $0 [options] <project-dir>"
      echo ""
      echo "Options:"
      echo "  --max-iterations N        Max loop iterations (default: 50)"
      echo "  --budget-per-iter N       Max USD per claude invocation (default: 5)"
      echo "  --total-budget N          Max total USD (default: 100)"
      echo "  --model MODEL             Model to use (default: sonnet)"
      echo "  --slack-webhook URL       Slack webhook URL"
      echo "  --skip-permissions        Enable --dangerously-skip-permissions"
      echo "  --auto-retry              Auto-retry on rate limits with backoff"
      echo "  --retry-delay N           Seconds to wait on rate limit (default: 1800)"
      echo "  --dry-run                 Show what would be executed"
      echo ""
      echo "Environment:"
      echo "  ANTHROPIC_API_KEY         Required (unless using subscription)"
      echo "  SLACK_WEBHOOK_URL         Slack webhook for notifications"
      exit 0
      ;;
    -*) echo "Unknown option: $1"; exit 1 ;;
    *) PROJECT_DIR="$1"; shift ;;
  esac
done

# Validate project directory
if [ -z "$PROJECT_DIR" ]; then
  echo -e "${RED}Error: Project directory is required${NC}"
  echo "Usage: $0 [options] <project-dir>"
  exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
  echo -e "${RED}Error: Project directory does not exist: $PROJECT_DIR${NC}"
  exit 1
fi

# Resolve to absolute path
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
STATE_FILE="$PROJECT_DIR/plans/build-state.json"

# Check for stage plans
if [ ! -d "$PROJECT_DIR/plans/active" ]; then
  echo -e "${RED}Error: No plans/active/ directory found in $PROJECT_DIR${NC}"
  echo "Run /launch-app first to create stage plans."
  exit 1
fi

STAGE_COUNT=$(find "$PROJECT_DIR/plans/active" -name "stage-*.md" 2>/dev/null | wc -l)
if [ "$STAGE_COUNT" -eq 0 ] && [ ! -f "$STATE_FILE" ]; then
  echo -e "${RED}Error: No stage plans found in $PROJECT_DIR/plans/active/${NC}"
  echo "Run /launch-app first to create stage plans."
  exit 1
fi

# ─── Helpers ───────────────────────────────────────────────────────────────────

notify_slack() {
  local message="$1"
  local color="${2:-#36a64f}"
  if [ -n "$SLACK_WEBHOOK" ]; then
    # Use temp file for payload to avoid Windows Git Bash quote mangling
    local tmpfile
    tmpfile=$(mktemp)
    cat > "$tmpfile" <<EOFSLACK
{"attachments":[{"color":"$color","text":"$message","footer":"build-app-runner | $(date -u +%Y-%m-%dT%H:%M:%SZ)"}]}
EOFSLACK
    curl -s -X POST "$SLACK_WEBHOOK" \
      -H "Content-type: application/json" \
      --data-binary @"$tmpfile" > /dev/null 2>&1 || true
    rm -f "$tmpfile"
  fi
}

get_state_field() {
  local field="$1"
  if [ -f "$STATE_FILE" ]; then
    # Use node for JSON parsing (available since claude CLI requires node)
    node -e "
      const fs = require('fs');
      try {
        const state = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));
        const value = '$field'.split('.').reduce((o, k) => o && o[k], state);
        console.log(value !== undefined && value !== null ? value : '');
      } catch(e) { console.log(''); }
    " 2>/dev/null || echo ""
  else
    echo ""
  fi
}

get_project_name() {
  if [ -f "$STATE_FILE" ]; then
    get_state_field "project"
  else
    basename "$PROJECT_DIR"
  fi
}

# ─── Pre-flight ────────────────────────────────────────────────────────────────

PROJECT_NAME="$(get_project_name)"

echo ""
echo -e "${BLUE}Build App Runner${NC}"
echo "=============================="
echo -e "Project:      ${GREEN}$PROJECT_NAME${NC}"
echo -e "Directory:    $PROJECT_DIR"
echo -e "Model:        $MODEL"
echo -e "Max iters:    $MAX_ITERATIONS"
echo -e "Budget/iter:  \$$BUDGET_PER_ITER"
echo -e "Total budget: \$$TOTAL_BUDGET"
echo -e "Permissions:  $([ "$SKIP_PERMISSIONS" = true ] && echo 'skip' || echo 'interactive')"
echo -e "Auto-retry:   $([ "$AUTO_RETRY" = true ] && echo "yes (${RETRY_DELAY}s delay)" || echo 'no')"
echo -e "Slack:        $([ -n "$SLACK_WEBHOOK" ] && echo 'enabled' || echo 'disabled')"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}DRY RUN — would execute the build loop above${NC}"
  exit 0
fi

# ─── Main Loop ─────────────────────────────────────────────────────────────────

ITERATION=0
NO_PROGRESS_COUNT=0
LAST_STATE_HASH=""

notify_slack "Build runner started for *$PROJECT_NAME* — up to $MAX_ITERATIONS iterations" "#2196F3"

while true; do
  ITERATION=$((ITERATION + 1))

  # ── Check iteration limit ──
  if [ "$ITERATION" -gt "$MAX_ITERATIONS" ]; then
    echo -e "${RED}Max iterations ($MAX_ITERATIONS) reached. Stopping.${NC}"
    notify_slack "Build runner stopped: max iterations ($MAX_ITERATIONS) reached for *$PROJECT_NAME*" "#ff0000"
    exit 1
  fi

  # ── Check state ──
  if [ -f "$STATE_FILE" ]; then
    STATUS="$(get_state_field "status")"
    CURRENT_STAGE="$(get_state_field "current_stage")"
    TOTAL_STAGES="$(get_state_field "total_stages")"

    if [ "$STATUS" = "complete" ]; then
      echo -e "${GREEN}Build complete!${NC}"
      notify_slack "Build complete: *$PROJECT_NAME* finished successfully" "#36a64f"
      exit 0
    fi

    if [ "$STATUS" = "failed" ]; then
      ERROR="$(get_state_field "stages.$CURRENT_STAGE.error" 2>/dev/null || echo "unknown")"
      echo -e "${RED}Build failed at stage $CURRENT_STAGE: $ERROR${NC}"
      echo "Run '/build-app resume' in the project directory to retry."
      notify_slack "Build FAILED for *$PROJECT_NAME* at stage $CURRENT_STAGE" "#ff0000"
      exit 1
    fi

    echo -e "${BLUE}[$ITERATION/$MAX_ITERATIONS]${NC} Stage $CURRENT_STAGE of $TOTAL_STAGES — status: $STATUS"
  else
    echo -e "${BLUE}[$ITERATION/$MAX_ITERATIONS]${NC} First run — initializing..."
  fi

  # ── No-progress detection ──
  if [ -f "$STATE_FILE" ]; then
    CURRENT_HASH=$(md5sum "$STATE_FILE" 2>/dev/null | cut -d' ' -f1 || md5 -q "$STATE_FILE" 2>/dev/null || echo "")
    if [ -n "$LAST_STATE_HASH" ] && [ "$CURRENT_HASH" = "$LAST_STATE_HASH" ]; then
      NO_PROGRESS_COUNT=$((NO_PROGRESS_COUNT + 1))
      echo -e "${YELLOW}Warning: No state change detected ($NO_PROGRESS_COUNT/3)${NC}"
      if [ "$NO_PROGRESS_COUNT" -ge 3 ]; then
        echo -e "${RED}No progress after 3 consecutive iterations. Stopping.${NC}"
        notify_slack "Build runner stopped: no progress after 3 iterations for *$PROJECT_NAME*" "#ff0000"
        exit 1
      fi
    else
      NO_PROGRESS_COUNT=0
    fi
    LAST_STATE_HASH="$CURRENT_HASH"
  fi

  # ── Build claude command ──
  CMD=(claude --print --model "$MODEL")

  if [ "$SKIP_PERMISSIONS" = true ]; then
    CMD+=(--dangerously-skip-permissions)
  fi

  # Add budget cap if not using subscription
  if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    CMD+=(--max-budget-usd "$BUDGET_PER_ITER")
  fi

  # The prompt tells claude to execute the build-app skill
  PROMPT="Execute /build-app to continue building this project. Read plans/build-state.json for current state. Build the next pending stage. Do not ask any questions — just build."

  CMD+=(-p "$PROMPT")

  echo -e "${GRAY}Running claude...${NC}"

  # ── Execute claude ──
  set +e
  (cd "$PROJECT_DIR" && "${CMD[@]}" 2>&1)
  EXIT_CODE=$?
  set -e

  echo ""

  # ── Handle exit code ──
  if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Claude exited successfully${NC}"
    # State will be checked at top of next iteration

  elif [ $EXIT_CODE -eq 2 ] || [ $EXIT_CODE -eq 75 ]; then
    # Rate limit or resource exhaustion
    echo -e "${YELLOW}Rate limit or resource exhaustion detected (exit $EXIT_CODE)${NC}"
    notify_slack "Build paused for *$PROJECT_NAME* — rate limit hit. $([ "$AUTO_RETRY" = true ] && echo "Will retry in ${RETRY_DELAY}s." || echo "Re-run to resume.")" "#9e9e9e"

    if [ "$AUTO_RETRY" = true ]; then
      echo -e "${YELLOW}Waiting ${RETRY_DELAY}s before retrying...${NC}"
      sleep "$RETRY_DELAY"
      continue
    else
      echo "Re-run this command after the rate limit resets to resume."
      exit 2
    fi

  elif [ $EXIT_CODE -eq 1 ]; then
    echo -e "${YELLOW}Claude exited with error (exit 1) — checking state...${NC}"
    # Check if state was updated (partial progress is ok)
    if [ -f "$STATE_FILE" ]; then
      STATUS="$(get_state_field "status")"
      if [ "$STATUS" = "failed" ]; then
        ERROR="$(get_state_field "stages.$(get_state_field current_stage).error" 2>/dev/null || echo "unknown")"
        echo -e "${RED}Build failed: $ERROR${NC}"
        notify_slack "Build FAILED for *$PROJECT_NAME*: $ERROR" "#ff0000"
        exit 1
      fi
      # Not marked as failed — might be a context window issue, continue
      echo -e "${YELLOW}Continuing despite error — state not marked as failed${NC}"
    fi

  else
    echo -e "${YELLOW}Claude exited with code $EXIT_CODE — continuing...${NC}"
  fi

  # Brief pause between iterations
  sleep 2
done
