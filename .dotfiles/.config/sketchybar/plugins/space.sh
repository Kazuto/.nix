#!/bin/bash

source "$CONFIG_DIR/colors.sh"

CURRENT_WORKSPACE=$"$(<~/.current_workspace)"

if [ "$1" = "$CURRENT_WORKSPACE" ]; then
	sketchybar --set $NAME drawing=on background.drawing=on \
      background.color=$CAT_PEACH \
      label.color=$CAT_BASE \
      icon.color=$CAT_BASE
else
	sketchybar --set $NAME drawing=on background.drawing=off \
                           label.color=$CAT_TEXT \
                           icon.color=$CAT_TEXT
fi
