#!/bin/bash

sketchybar --add item media center \
           --set media label.max_chars=60 \
                       icon.padding_left=0 \
                       scroll_texts=on \
                       icon=󰓇 \
                       icon.color=$CAT_GREEN \
                       icon.padding_right=6 \
                       background.drawing=off \
                       y_offset=1 \
                       script="$PLUGIN_DIR/media.sh" \
           --subscribe media media_change 
