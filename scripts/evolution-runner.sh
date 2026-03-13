#!/bin/bash

# Evolution Runner
# Outer loop that drives the evolution cycle by reading factory/evolution-state.json
# and invoking the correct skill until reaching a human gate or completion.
#
# Usage: ./scripts/evolution-runner.sh [options] <project-dir>
#
# Options:
#   --max-cycles N            Max evolution cycles to run (default: 10)
#   --max-iterations N        Max loop iterations per cycle (default: 20)
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

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
CYAN='\033[0;36m'
NC='\033[0m'

# Defaults
MAX_CYCLES="${EVOLUTION_MAX_CYCLES:-10}"
MAX_ITERATIONS="${EVOLUTION_MAX_ITERATIONS:-20}"
BUDGET_PER_ITER="${EVOLUTION_BUDGET_PER_ITER:-5}"
TOTAL_BUDGET="${EVOLUTION_TOTAL_BUDGET:-100}"
MODEL="${EVOLUTION_MODEL:-sonnet}"
SLACK_WEBHOOK="${SLACK_WEBHOOK_URL:-}"
SKIP_PERMISSIONS=false
AUTO_RETRY=false
RETRY_DELAY=1800
DRY_RUN=false
PROJECT_DIR=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --max-cycles) MAX_CYCLES="$2"; shift 2 ;;
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
      echo "  --max-cycles N            Max evolution cycles (default: 10)"
      echo "  --max-iterations N        Max loop iterations per cycle (default: 20)"
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
EVOLUTION_STATE="$PROJECT_DIR/factory/evolution-state.json"

# ─── Helpers ───────────────────────────────────────────────────────────────────

notify_slack() {
  local message="$1"
  local color="${2:-#36a64f}"
  if [ -n "$SLACK_WEBHOOK" ]; then
    local tmpfile
    tmpfile=$(mktemp)
    cat > "$tmpfile" <<EOFSLACK
{"attachments":[{"color":"$color","text":"$message","footer":"evolution-runner | $(date -u +%Y-%m-%dT%H:%M:%SZ)"}]}
EOFSLACK
    curl -s -X POST "$SLACK_WEBHOOK" \
      -H "Content-type: application/json" \
      --data-binary @"$tmpfile" > /dev/null 2>&1 || true
    rm -f "$tmpfile"
  fi
}

get_evolution_field() {
  local field="$1"
  if [ -f "$EVOLUTION_STATE" ]; then
    node -e "
      const fs = require('fs');
      try {
        const state = JSON.parse(fs.readFileSync('$EVOLUTION_STATE', 'utf8'));
        const value = '$field'.split('.').reduce((o, k) => o && o[k], state);
        console.log(value !== undefined && value !== null ? value : '');
      } catch(e) { console.log(''); }
    " 2>/dev/null || echo ""
  else
    echo ""
  fi
}

get_project_name() {
  if [ -f "$EVOLUTION_STATE" ]; then
    get_evolution_field "project"
  else
    basename "$PROJECT_DIR"
  fi
}

# Map evolution status to the skill/prompt to invoke
get_skill_for_status() {
  local status="$1"
  case "$status" in
    ""|"idle"|"approved")
      echo "evaluate-product"
      ;;
    "evaluating")
      echo "evaluate-product"
      ;;
    "hypothesizing")
      echo "generate-hypotheses"
      ;;
    "planning")
      echo "plan-optimization"
      ;;
    "building")
      echo "build-app"
      ;;
    "preview_deployed"|"awaiting_approval")
      echo "HUMAN_GATE"
      ;;
    "rejected")
      echo "generate-hypotheses"
      ;;
    *)
      echo "evaluate-product"
      ;;
  esac
}

get_prompt_for_skill() {
  local skill="$1"
  case "$skill" in
    "evaluate-product")
      echo "Execute /evaluate-product to evaluate this product. Read factory/evolution-state.json for current state. Score all dimensions, run user journey simulations, and write output files. Do not ask any questions — just evaluate."
      ;;
    "generate-hypotheses")
      echo "Execute /generate-hypotheses to generate optimization proposals. Read the latest evaluation and hypothesis history. Generate ranked hypotheses and batch the top 2-3. Do not ask any questions — just generate."
      ;;
    "plan-optimization")
      echo "Execute /plan-optimization to create an executable stage plan from the latest hypotheses. Write a stage plan to plans/active/ that /build-app can execute. Do not ask any questions — just plan."
      ;;
    "build-app")
      echo "Execute /build-app to build the optimization stage plan. Read plans/build-state.json for current state. Build the next pending stage. Do not ask any questions — just build."
      ;;
    *)
      echo "Check factory/evolution-state.json and continue the evolution loop."
      ;;
  esac
}

# ─── Pre-flight ────────────────────────────────────────────────────────────────

PROJECT_NAME="$(get_project_name)"

echo ""
echo -e "${CYAN}Evolution Runner${NC}"
echo "=============================="
echo -e "Project:      ${GREEN}$PROJECT_NAME${NC}"
echo -e "Directory:    $PROJECT_DIR"
echo -e "Model:        $MODEL"
echo -e "Max cycles:   $MAX_CYCLES"
echo -e "Max iters:    $MAX_ITERATIONS"
echo -e "Budget/iter:  \$$BUDGET_PER_ITER"
echo -e "Total budget: \$$TOTAL_BUDGET"
echo -e "Permissions:  $([ "$SKIP_PERMISSIONS" = true ] && echo 'skip' || echo 'interactive')"
echo -e "Auto-retry:   $([ "$AUTO_RETRY" = true ] && echo "yes (${RETRY_DELAY}s delay)" || echo 'no')"
echo -e "Slack:        $([ -n "$SLACK_WEBHOOK" ] && echo 'enabled' || echo 'disabled')"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}DRY RUN — would execute the evolution loop above${NC}"
  exit 0
fi

# ─── Main Loop ─────────────────────────────────────────────────────────────────

ITERATION=0
NO_PROGRESS_COUNT=0
LAST_STATE_HASH=""

notify_slack "Evolution runner started for *$PROJECT_NAME* — up to $MAX_CYCLES cycles" "#2196F3"

while true; do
  ITERATION=$((ITERATION + 1))

  # ── Check iteration limit ──
  if [ "$ITERATION" -gt "$MAX_ITERATIONS" ]; then
    echo -e "${RED}Max iterations ($MAX_ITERATIONS) reached. Stopping.${NC}"
    notify_slack "Evolution runner stopped: max iterations ($MAX_ITERATIONS) reached for *$PROJECT_NAME*" "#ff0000"
    exit 1
  fi

  # ── Read evolution state ──
  STATUS=""
  CYCLE=""
  if [ -f "$EVOLUTION_STATE" ]; then
    STATUS="$(get_evolution_field "status")"
    CYCLE="$(get_evolution_field "current_cycle")"
    COMPLETED="$(get_evolution_field "total_cycles_completed")"

    # Check cycle limit
    if [ -n "$COMPLETED" ] && [ "$COMPLETED" -ge "$MAX_CYCLES" ]; then
      echo -e "${GREEN}Max cycles ($MAX_CYCLES) completed. Stopping.${NC}"
      notify_slack "Evolution runner completed: $MAX_CYCLES cycles for *$PROJECT_NAME*" "#36a64f"
      exit 0
    fi
  fi

  # ── Determine which skill to invoke ──
  SKILL="$(get_skill_for_status "$STATUS")"

  # ── Human gate — stop and notify ──
  if [ "$SKILL" = "HUMAN_GATE" ]; then
    echo -e "${YELLOW}Preview deployed — awaiting human approval.${NC}"
    echo ""
    echo "Review the preview deployment, then run:"
    echo "  /evolution-gate approve    — merge to production"
    echo "  /evolution-gate reject     — discard and try next"
    echo ""
    echo "Then re-run this script to continue evolution."
    notify_slack "Evolution cycle $CYCLE for *$PROJECT_NAME* ready for review — preview deployed. Run /evolution-gate approve or reject." "#2196F3"
    exit 0
  fi

  echo -e "${BLUE}[$ITERATION/$MAX_ITERATIONS]${NC} Cycle $CYCLE — status: ${STATUS:-new} → invoking /$SKILL"

  # ── No-progress detection ──
  if [ -f "$EVOLUTION_STATE" ]; then
    CURRENT_HASH=$(md5sum "$EVOLUTION_STATE" 2>/dev/null | cut -d' ' -f1 || md5 -q "$EVOLUTION_STATE" 2>/dev/null || echo "")
    if [ -n "$LAST_STATE_HASH" ] && [ "$CURRENT_HASH" = "$LAST_STATE_HASH" ]; then
      NO_PROGRESS_COUNT=$((NO_PROGRESS_COUNT + 1))
      echo -e "${YELLOW}Warning: No state change detected ($NO_PROGRESS_COUNT/3)${NC}"
      if [ "$NO_PROGRESS_COUNT" -ge 3 ]; then
        echo -e "${RED}No progress after 3 consecutive iterations. Stopping.${NC}"
        notify_slack "Evolution runner stopped: no progress after 3 iterations for *$PROJECT_NAME*" "#ff0000"
        exit 1
      fi
    else
      NO_PROGRESS_COUNT=0
    fi
    LAST_STATE_HASH="$CURRENT_HASH"
  fi

  # ── Build claude command ──
  PROMPT="$(get_prompt_for_skill "$SKILL")"
  CMD=(claude --print --model "$MODEL")

  if [ "$SKIP_PERMISSIONS" = true ]; then
    CMD+=(--dangerously-skip-permissions)
  fi

  if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    CMD+=(--max-budget-usd "$BUDGET_PER_ITER")
  fi

  CMD+=(-p "$PROMPT")

  echo -e "${GRAY}Running claude (/$SKILL)...${NC}"

  # ── Execute claude ──
  set +e
  (cd "$PROJECT_DIR" && "${CMD[@]}" 2>&1)
  EXIT_CODE=$?
  set -e

  echo ""

  # ── Handle exit code ──
  if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Claude exited successfully${NC}"

  elif [ $EXIT_CODE -eq 2 ] || [ $EXIT_CODE -eq 75 ]; then
    echo -e "${YELLOW}Rate limit or resource exhaustion detected (exit $EXIT_CODE)${NC}"
    notify_slack "Evolution paused for *$PROJECT_NAME* — rate limit hit. $([ "$AUTO_RETRY" = true ] && echo "Will retry in ${RETRY_DELAY}s." || echo "Re-run to resume.")" "#9e9e9e"

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
    if [ -f "$EVOLUTION_STATE" ]; then
      NEW_STATUS="$(get_evolution_field "status")"
      if [ "$NEW_STATUS" != "$STATUS" ]; then
        echo -e "${YELLOW}State changed ($STATUS → $NEW_STATUS) — continuing${NC}"
      else
        echo -e "${YELLOW}State unchanged — will retry${NC}"
      fi
    fi

  else
    echo -e "${YELLOW}Claude exited with code $EXIT_CODE — continuing...${NC}"
  fi

  # Brief pause between iterations
  sleep 2
done
