#!/bin/bash

sketchybar --add item cpu right \
  --set cpu update_freq=2 \
  icon=􀫥 \
  icon.color=$CAT_PEACH \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/cpu.sh" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1" \
  --subscribe cpu mouse.entered mouse.exited mouse.exited.global

for item in "total" "user" "sys"; do
  sketchybar --add item "cpu.${item}" popup.cpu \
    --set "cpu.${item}" \
    padding_left=16 \
    padding_right=16 \
    background.drawing=off
done

for i in 1 2 3 4 5; do
  sketchybar --add item "cpu.top${i}" popup.cpu \
    --set "cpu.top${i}" \
    padding_left=16 \
    padding_right=16 \
    background.drawing=off
done
