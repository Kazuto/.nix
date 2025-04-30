#!/bin/bash

sketchybar --add item timer right \
           --set timer label="No Timer" \
                       icon=􀐱 \
                       icon.color="$CAT_YELLOW" \
                       icon.padding_right=6 \
                       background.drawing=off \
                       y_offset=1 \
                       script="$PLUGIN_DIR/timer.sh" \
                       popup.background.corner_radius=10                               \
                       popup.background.color="$CAT_BASE"                       \
                       popup.background.border_width=1 \
                       popup.background.border_color="$CAT_SURFACE1" \
                       --subscribe timer mouse.clicked mouse.entered mouse.exited mouse.exited.global 

for timer in "5" "10" "25"; do
sketchybar --add item "timer.${timer}" popup.timer \
            --set "timer.${timer}" label="${timer} Minutes" \
                        padding_left=16 \
                        padding_right=16 \
                        click_script="$PLUGIN_DIR/timer.sh $((timer * 60)); sketchybar -m --set timer popup.drawing=off"
done
