#!/bin/bash

sketchybar --add item media center \
           --set media label.color=$ITEM_TEXT_COLOR \
                       label.max_chars=30 \
                       icon.padding_left=0 \
                       scroll_texts=on \
                       icon=􀑪             \
                       icon.color=$ITEM_TEXT_COLOR   \
                       background.drawing=off \
                       script="$PLUGIN_DIR/media.sh" \
           --subscribe media media_change
