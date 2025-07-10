#!/bin/bash

#echo space.sh $'FOCUSED_WORKSPACE': $FOCUSED_WORKSPACE, $'SELECTED': $SELECTED, NAME: $NAME, SENDER: $SENDER  >> ~/aaaa

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
	sketchybar --set $NAME drawing=on background.drawing=on \
      background.color=$CAT_PEACH \
      label.color=$CAT_BASE \
      label.shadow.drawing=off \
      icon.color=$CAT_BASE
else
	sketchybar --set $NAME drawing=on background.drawing=off \
                           label.color=$CAT_TEXT \
                           icon.color=$CAT_TEXT
fi
