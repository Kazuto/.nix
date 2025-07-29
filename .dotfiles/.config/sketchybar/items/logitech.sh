#!/bin/bash

sketchybar --add item logitech.keyboard right \
  --set logitech.keyboard update_freq=120 \
  icon=􀢋 \
  icon.color="$CAT_SKY" \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/logitech.sh ED9B3216"

sketchybar --add item logitech.mouse right \
  --set logitech.mouse update_freq=120 \
  icon=􀢋 \
  icon.color="$CAT_SKY" \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/logitech.sh B2CF7061"
