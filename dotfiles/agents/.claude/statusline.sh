#!/bin/bash
input=$(cat)

# Model
MODEL=$(echo "$input" | jq -r '.model.display_name')

# Context window percentage + progress bar
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; CYAN='\033[36m'; DIM='\033[2m'; RESET='\033[0m'

if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '█')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

# Usage stats
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '$%.2f' "$COST")
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
MINS=$((DURATION_MS / 60000))
SECS=$(((DURATION_MS % 60000) / 1000))
SESSION_ID=$(echo "$input" | jq -r '.session_id')

# Monthly cost accumulator
MONTHLY_CACHE="$HOME/.claude/.statusline-monthly-costs"
MONTHLY_LOCK="${MONTHLY_CACHE}.lockdir"
CURRENT_MONTH=$(date +%Y-%m)

# Update current session's cost atomically using mkdir lock (format: YYYY-MM session_id cost)
_retries=0
while ! mkdir "$MONTHLY_LOCK" 2>/dev/null; do
  _retries=$((_retries + 1))
  [ "$_retries" -ge 50 ] && { rm -rf "$MONTHLY_LOCK"; mkdir "$MONTHLY_LOCK" 2>/dev/null; break; }
  sleep 0.01
done
trap 'rm -rf "$MONTHLY_LOCK"' EXIT

if [ -f "$MONTHLY_CACHE" ]; then
  grep -v "$SESSION_ID" "$MONTHLY_CACHE" > "${MONTHLY_CACHE}.tmp" 2>/dev/null || true
  mv "${MONTHLY_CACHE}.tmp" "$MONTHLY_CACHE"
fi
echo "$CURRENT_MONTH $SESSION_ID $COST" >> "$MONTHLY_CACHE"

rm -rf "$MONTHLY_LOCK"
trap - EXIT

# Sum all costs for current month
MONTHLY_COST=$(awk -v month="$CURRENT_MONTH" '$1 == month { sum += $3 } END { printf "%.2f", sum }' "$MONTHLY_CACHE")
MONTHLY_FMT=$(printf '$%s' "$MONTHLY_COST")

# Format token counts (e.g. 15234 -> 15.2k)
fmt_tokens() {
  local t=$1
  if [ "$t" -ge 1000000 ]; then
    printf "%.1fM" "$(echo "$t / 1000000" | bc -l)"
  elif [ "$t" -ge 1000 ]; then
    printf "%.1fk" "$(echo "$t / 1000" | bc -l)"
  else
    echo "$t"
  fi
}

IN_FMT=$(fmt_tokens "$INPUT_TOKENS")
OUT_FMT=$(fmt_tokens "$OUTPUT_TOKENS")

# Line 1: Context
echo -e "${CYAN}[$MODEL]${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}% context"
# Line 2: Usage
echo -e "${DIM}↑${RESET}${IN_FMT} ${DIM}↓${RESET}${OUT_FMT} ${DIM}|${RESET} ${YELLOW}~${COST_FMT} est.${RESET} ${DIM}(${MONTHLY_FMT} this mo)${RESET} ${DIM}|${RESET} ⏱ ${MINS}m${SECS}s"
