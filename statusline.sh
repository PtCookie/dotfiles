#!/usr/bin/env bash

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
TOTAL_INPUT=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
TOTAL_OUTPUT=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')
FIVE_HOUR_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_HOUR_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_DAY_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SEVEN_DAY_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Build progress bar (10 blocks wide)
if [ "$PCT" -ge 90 ]; then
	BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then
	BAR_COLOR="$YELLOW"
elif [ "$PCT" -ge 40 ]; then
	BAR_COLOR="$GREEN"
else BAR_COLOR=""; fi

BAR=""
if [ -n "$PCT" ]; then
	FILLED=$(echo "$PCT" | awk '{printf "%d", ($1 * 10 / 100) + 0.5}')
	EMPTY=$((10 - FILLED))
	BAR_FILLED=$(printf '%*s' "$FILLED" '' | tr ' ' '█')
	BAR_EMPTY=$(printf '%*s' "$EMPTY" '' | tr ' ' '░')

	BAR="[${BAR_COLOR}${BAR_FILLED}${BAR_EMPTY}${RESET}]"
	PCT_FMT="${BAR_COLOR}$(printf "%.0f%%" "$PCT")${RESET}"
fi

format_tokens() {
	local n=$1
	if [ "$n" -ge 1000 ]; then
		echo "$n" | awk '{printf "%gK", $1/1000}'
	else
		echo "$n"
	fi
}

IN_FMT=$(format_tokens "$TOTAL_INPUT")
OUT_FMT=$(format_tokens "$TOTAL_OUTPUT")

COST_FMT="${YELLOW}$(printf '$%.2f' "$COST")${RESET}"

MINS=$((DURATION_MS / 60000))
SECS=$(((DURATION_MS % 60000) / 1000))
DURATION="${MINS}m ${SECS}s"

# Assemble output
STATUSLINE=""

# Model (with reasoning effort, when available)
if [ -n "$EFFORT" ]; then
	STATUSLINE="${CYAN}[${MODEL}|${EFFORT}]${RESET}"
else
	STATUSLINE="${CYAN}[${MODEL}]${RESET}"
fi

# Context bar
if [ -n "$BAR" ]; then
	STATUSLINE="${STATUSLINE}  ctx:${BAR} ${PCT_FMT}"
fi
STATUSLINE="${STATUSLINE} (in:${IN_FMT} / out:${OUT_FMT})"

# Cost
STATUSLINE="${STATUSLINE}  ${COST_FMT}"

# Duration (only for API response)
STATUSLINE="${STATUSLINE}  ${DURATION}"

# 5-hour rate limit (subscription usage), on its own line
if [ -n "$FIVE_HOUR_PCT" ]; then
	if [ "$(echo "$FIVE_HOUR_PCT" | awk '{print ($1>=90)}')" = "1" ]; then
		FIVE_HOUR_COLOR="$RED"
	elif [ "$(echo "$FIVE_HOUR_PCT" | awk '{print ($1>=70)}')" = "1" ]; then
		FIVE_HOUR_COLOR="$YELLOW"
	else
		FIVE_HOUR_COLOR="$GREEN"
	fi

	FIVE_HOUR_FILLED=$(echo "$FIVE_HOUR_PCT" | awk '{printf "%d", ($1 * 10 / 100) + 0.5}')
	FIVE_HOUR_EMPTY=$((10 - FIVE_HOUR_FILLED))
	FIVE_HOUR_BAR_FILLED=$(printf '%*s' "$FIVE_HOUR_FILLED" '' | tr ' ' '█')
	FIVE_HOUR_BAR_EMPTY=$(printf '%*s' "$FIVE_HOUR_EMPTY" '' | tr ' ' '░')
	FIVE_HOUR_BAR="[${FIVE_HOUR_COLOR}${FIVE_HOUR_BAR_FILLED}${FIVE_HOUR_BAR_EMPTY}${RESET}]"

	FIVE_HOUR_FMT="${FIVE_HOUR_COLOR}$(printf '%.0f%%' "$FIVE_HOUR_PCT")${RESET}"
	FIVE_HOUR_LINE="5h:${FIVE_HOUR_BAR} ${FIVE_HOUR_FMT}"

	if [ -n "$FIVE_HOUR_RESET" ]; then
		RESET_FMT=$(date -r "$FIVE_HOUR_RESET" "+%H:%M" 2>/dev/null)
		[ -n "$RESET_FMT" ] && FIVE_HOUR_LINE="${FIVE_HOUR_LINE} (resets ${RESET_FMT})"
	fi

	STATUSLINE="${STATUSLINE}\n${FIVE_HOUR_LINE}"
fi

# 7-day rate limit (subscription usage), alongside the 5-hour limit
if [ -n "$SEVEN_DAY_PCT" ]; then
	if [ "$(echo "$SEVEN_DAY_PCT" | awk '{print ($1>=90)}')" = "1" ]; then
		SEVEN_DAY_COLOR="$RED"
	elif [ "$(echo "$SEVEN_DAY_PCT" | awk '{print ($1>=70)}')" = "1" ]; then
		SEVEN_DAY_COLOR="$YELLOW"
	else
		SEVEN_DAY_COLOR="$GREEN"
	fi

	SEVEN_DAY_FILLED=$(echo "$SEVEN_DAY_PCT" | awk '{printf "%d", ($1 * 10 / 100) + 0.5}')
	SEVEN_DAY_EMPTY=$((10 - SEVEN_DAY_FILLED))
	SEVEN_DAY_BAR_FILLED=$(printf '%*s' "$SEVEN_DAY_FILLED" '' | tr ' ' '█')
	SEVEN_DAY_BAR_EMPTY=$(printf '%*s' "$SEVEN_DAY_EMPTY" '' | tr ' ' '░')
	SEVEN_DAY_BAR="[${SEVEN_DAY_COLOR}${SEVEN_DAY_BAR_FILLED}${SEVEN_DAY_BAR_EMPTY}${RESET}]"

	SEVEN_DAY_FMT="${SEVEN_DAY_COLOR}$(printf '%.0f%%' "$SEVEN_DAY_PCT")${RESET}"
	SEVEN_DAY_LINE="7d:${SEVEN_DAY_BAR} ${SEVEN_DAY_FMT}"

	if [ -n "$SEVEN_DAY_RESET" ]; then
		RESET_FMT=$(date -r "$SEVEN_DAY_RESET" "+%m/%d %H:%M" 2>/dev/null)
		[ -n "$RESET_FMT" ] && SEVEN_DAY_LINE="${SEVEN_DAY_LINE} (resets ${RESET_FMT})"
	fi

	if [ -n "$FIVE_HOUR_PCT" ]; then
		STATUSLINE="${STATUSLINE}  ${SEVEN_DAY_LINE}"
	else
		STATUSLINE="${STATUSLINE}\n${SEVEN_DAY_LINE}"
	fi
fi

printf "%b" "$STATUSLINE"
