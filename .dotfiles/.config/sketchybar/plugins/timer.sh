#!/bin/bash

# Prevent globbing and word splitting
set -f
IFS=$'\n\t'

COUNTDOWN_PID_FILE="/tmp/sketchybar_timer_pid"
DEFAULT_DURATION=1500  # 25 minutes

get_duration() {
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "$1"
  else
    echo "$DEFAULT_DURATION"
  fi
}

start_countdown() {
  local name="$1"
  local duration="$2"

  (
    local time_left="$duration"

    while [ "$time_left" -gt 0 ]; do
      local minutes=$((time_left / 60))
      local seconds=$((time_left % 60))
      sketchybar --set "$name" label="$(printf "%02d:%02d" "$minutes" "$seconds")"
      sleep 1
      time_left=$((time_left - 1))
    done

    sketchybar --set "$name" label="Done"
  ) &
  printf "%s\n" "$!" > "$COUNTDOWN_PID_FILE"
}

stop_countdown() {
  if [ -f "$COUNTDOWN_PID_FILE" ]; then
    if IFS= read -r PID < "$COUNTDOWN_PID_FILE"; then
      if ps -p "$PID" > /dev/null 2>&1; then
        kill -- "$PID"
      fi
    fi
    rm -f "$COUNTDOWN_PID_FILE"
  fi
}

# If script is run directly with a duration argument (e.g. ./timer.sh 300)
if [[ "$#" -eq 1 && "$1" =~ ^[0-9]+$ ]]; then
  stop_countdown
  start_countdown "timer" "$1"
  exit 0
fi

# Handle SketchyBar mouse events
if [ "$SENDER" = "mouse.clicked" ]; then
  case "$BUTTON" in
    "left")
      stop_countdown
      start_countdown "$NAME" "$DEFAULT_DURATION"
      ;;
    "right")
      stop_countdown
      sketchybar --set "$NAME" label="No Timer"
      ;;
  esac
fi

case "$SENDER" in
  "mouse.entered")
    sketchybar --set "$NAME" popup.drawing=on
    ;;
  "mouse.exited"|"mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off
    ;;
esac
