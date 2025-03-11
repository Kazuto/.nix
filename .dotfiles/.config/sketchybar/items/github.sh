#!/bin/bash

sketchybar --add item github right \
           --set github icon=":git_hub:" \
                        icon.font="sketchybar-app-font:Regular:13.0" \
                        icon.color=$CAT_BLUE \
                        label.padding_left=6 \
                        label.drawing=off \
                        y_offset=1 \
                        update_freq=300 \
                        click_script="open https://github.com/notifications" \
                        script="$PLUGIN_DIR/github.sh"
