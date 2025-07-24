#!/bin/bash

sketchybar --add item front_app left \
  --set front_app background.color=$CAT_PEACH \
  icon.color=$CAT_BASE \
  icon.font="sketchybar-app-font:Regular:16.0" \
  icon.padding_left=10 \
  icon.padding_right=5 \
  label.padding_right=10 \
  label.color=$CAT_BASE \
  label.shadow.drawing=off \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
