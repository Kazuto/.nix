#!/bin/bash

sketchybar --add item network right \
  --set network update_freq=2 \
  icon=􀤆 \
  icon.color=$CAT_GREEN \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/network.sh" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1" \
  --subscribe network mouse.entered mouse.exited mouse.exited.global

for item in "interface" "ip"; do
  sketchybar --add item "network.${item}" popup.network \
    --set "network.${item}" \
    padding_left=16 \
    padding_right=16 \
    background.drawing=off
done
