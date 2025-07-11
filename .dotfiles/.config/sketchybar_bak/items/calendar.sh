#!/bin/bash

sketchybar --add item calendar right \
  --set calendar icon=􀉉 \
  icon.color=$CAT_BLUE \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  update_freq=30 \
  script="$PLUGIN_DIR/calendar.sh"
