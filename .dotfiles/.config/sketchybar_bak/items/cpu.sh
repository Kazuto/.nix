#!/bin/bash

sketchybar --add item cpu right \
  --set cpu update_freq=2 \
  icon=􀫥 \
  icon.color=$CAT_PEACH \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/cpu.sh"
