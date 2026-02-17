#!/bin/bash

sketchybar --add item memory right \
  --set memory update_freq=5 \
  icon=􀫦 \
  icon.color=$CAT_YELLOW \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/memory.sh" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1" \
  --subscribe memory mouse.entered mouse.exited mouse.exited.global

for item in "usage" "active" "wired" "compressed"; do
  sketchybar --add item "memory.${item}" popup.memory \
    --set "memory.${item}" \
    padding_left=16 \
    padding_right=16 \
    background.drawing=off
done
