#!/bin/bash

# Read the JSON input
input=$(cat)

# Extract values using jq
MODEL_NAME=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
SESSION_NAME=$(echo "$input" | jq -r '.session_name // empty')
CONTEXT_REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
CONTEXT_USED=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# Initialize status components
status_parts=()

# Add model info
status_parts+=("$(printf '\033[38;5;4m%s\033[0m' "$MODEL_NAME")")

# Add session name if available
if [ -n "$SESSION_NAME" ]; then
  status_parts+=("$(printf '\033[38;5;6m%s\033[0m' "$SESSION_NAME")")
fi

# Add directory, shortened for readability
short_dir=$(basename "$CURRENT_DIR")
if [ "$short_dir" = "home" ] || [ "$short_dir" = "$(whoami)" ]; then
  dir_display="~"
else
  dir_display="$short_dir"
fi
status_parts+=("$(printf '\033[38;5;2m%s\033[0m' "$dir_display")")

# Add context usage if available
if [ -n "$CONTEXT_REMAINING" ]; then
  if [ "$CONTEXT_REMAINING" -gt 50 ]; then
    status_parts+=("$(printf '\033[38;5;2mCtx:%d%%\033[0m' "$CONTEXT_REMAINING")")
  elif [ "$CONTEXT_REMAINING" -gt 20 ]; then
    status_parts+=("$(printf '\033[38;5;3mCtx:%d%%\033[0m' "$CONTEXT_REMAINING")")
  else
    status_parts+=("$(printf '\033[38;5;1mCtx:%d%%\033[0m' "$CONTEXT_REMAINING")")
  fi
elif [ -n "$CONTEXT_USED" ]; then
  if [ "$CONTEXT_USED" -lt 50 ]; then
    status_parts+=("$(printf '\033[38;5;2mCtx:%d%%\033[0m' "$CONTEXT_USED")")
  elif [ "$CONTEXT_USED" -lt 80 ]; then
    status_parts+=("$(printf '\033[38;5;3mCtx:%d%%\033[0m' "$CONTEXT_USED")")
  else
    status_parts+=("$(printf '\033[38;5;1mCtx:%d%%\033[0m' "$CONTEXT_USED")")
  fi
fi

if [ -n "$DURATION_MS" ]; then
  DURATION_SEC=$((DURATION_MS / 1000))
  MINS=$((DURATION_SEC / 60))
  SECS=$((DURATION_SEC % 60))

  status_parts+=("$(printf '\033[38;5;2m%dms\033[0m' "${MINS}m ${SECS}s")")
fi

# Join parts with spaces
IFS=" "
echo "${status_parts[*]}"
