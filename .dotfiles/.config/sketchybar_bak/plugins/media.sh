#!/bin/bash

STATE="$(echo "$INFO" | jq -r '.state')"
MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
if [ "$STATE" = "playing" ]; then
  sketchybar --set $NAME label="$MEDIA" drawing=on
else
  sketchybar --set $NAME label="$MEDIA [Paused]" drawing=on
fi
