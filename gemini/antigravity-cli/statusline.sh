#!/usr/bin/env bash

# Avoid hanging on interactive terminal without stdin
[ -t 0 ] && input="{}" || input=$(cat)
[ -z "$input" ] && input="{}"

# Parse and normalize fields using jq in a single pass
{
	read -r MODEL
	read -r PCT
	read -r IN_FMT
	read -r OUT_FMT
	read -r COST
	read -r DURATION_MS
	read -r FIVE_HOUR_PCT
	read -r FIVE_HOUR_RESET
	read -r SEVEN_DAY_PCT
	read -r SEVEN_DAY_RESET
} <<< "$(echo "$input" | jq -r '
  def qbucket(key; pat; rl):
    rl // .quota[key] // (.quota // {} | to_entries | map(select(.key | test(pat)))[0].value) // {};
  def qpct(b):
    if b.used_percentage != null then b.used_percentage | round
    elif b.remaining_fraction != null then ((1.0 - b.remaining_fraction) * 100) | round
    else "" end;
  def qrst(b; fmt):
    if b.resets_at != null then (b.resets_at | try strflocaltime(fmt) catch "")
    elif b.reset_in_seconds != null then (now + b.reset_in_seconds | floor | try strflocaltime(fmt) catch "")
    elif b.reset_time != null then (b.reset_time | try fromdateiso8601 | try strflocaltime(fmt) catch "")
    else "" end;
  def fmt_tokens:
    if . >= 1000000 then "\((. / 100000 | round) / 10)M"
    elif . >= 1000 then "\((. / 100 | round) / 10)K"
    else tostring end;

  (qbucket("gemini-5h"; "5h"; .rate_limits.five_hour)) as $b5 |
  (qbucket("gemini-weekly"; "week|7d"; .rate_limits.seven_day)) as $b7 |
  (.effort.level // .thinking_level // .model.thinking_level // "") as $eff |
  (.model.display_name // .model.id // "Unknown Model") as $m |

  (if $eff != "" and ($m | ascii_downcase | contains($eff | ascii_downcase) | not) then "\($m)|\($eff)" else $m end),
  (.context_window.used_percentage // (if (.context_window.context_window_size // 0) > 0 then (((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)) * 100 / .context_window.context_window_size) else null end) | if . != null then round else "" end),
  (.context_window.total_input_tokens // 0 | fmt_tokens),
  (.context_window.total_output_tokens // 0 | fmt_tokens),
  (.cost.total_cost_usd // ""),
  (.cost.total_api_duration_ms // .duration_ms // ""),
  qpct($b5),
  qrst($b5; "%H:%M"),
  qpct($b7),
  qrst($b7; "%m/%d %H:%M")
' 2>/dev/null)"

CYAN='\033[36m' GREEN='\033[32m' YELLOW='\033[33m' RED='\033[31m' RESET='\033[0m'
BLOCKS="██████████" SPACES="░░░░░░░░░░"

# Build progress bar: [██░░░░░░░░] 20%
render_bar() {
	local pct=$1 min_green=${2:-0}
	[ -z "$pct" ] && return
	local color=""
	if [ "$pct" -ge 90 ]; then color="$RED"
	elif [ "$pct" -ge 70 ]; then color="$YELLOW"
	elif [ "$pct" -ge "$min_green" ]; then color="$GREEN"
	fi
	local filled=$(( (pct + 5) / 10 ))
	[ "$filled" -gt 10 ] && filled=10
	[ "$filled" -lt 0 ] && filled=0
	local empty=$((10 - filled))
	printf "[%b%s%s%b] %b%d%%%b" "$color" "${BLOCKS:0:filled}" "${SPACES:0:empty}" "$RESET" "$color" "$pct" "$RESET"
}

# Assemble statusline
STATUSLINE="${CYAN}[${MODEL}]${RESET}"
[ -n "$PCT" ] && STATUSLINE="${STATUSLINE}  ctx:$(render_bar "$PCT" 40)"
STATUSLINE="${STATUSLINE} (in:${IN_FMT} / out:${OUT_FMT})"

[ -n "$COST" ] && STATUSLINE="${STATUSLINE}  ${YELLOW}$(printf '$%.2f' "$COST")${RESET}"

if [ -n "$DURATION_MS" ] && [ "$DURATION_MS" -gt 0 ] 2>/dev/null; then
	STATUSLINE="${STATUSLINE}  $((DURATION_MS / 60000))m $(((DURATION_MS % 60000) / 1000))s"
fi

# Quota / Rate limits
QUOTA_LINE=""
if [ -n "$FIVE_HOUR_PCT" ]; then
	QUOTA_LINE="5h:$(render_bar "$FIVE_HOUR_PCT")"
	[ -n "$FIVE_HOUR_RESET" ] && QUOTA_LINE="${QUOTA_LINE} (resets ${FIVE_HOUR_RESET})"
fi
if [ -n "$SEVEN_DAY_PCT" ]; then
	LINE_7D="7d:$(render_bar "$SEVEN_DAY_PCT")"
	[ -n "$SEVEN_DAY_RESET" ] && LINE_7D="${LINE_7D} (resets ${SEVEN_DAY_RESET})"
	QUOTA_LINE="${QUOTA_LINE:+${QUOTA_LINE}  }${LINE_7D}"
fi
[ -n "$QUOTA_LINE" ] && STATUSLINE="${STATUSLINE}\n${QUOTA_LINE}"

printf "%b" "$STATUSLINE"
