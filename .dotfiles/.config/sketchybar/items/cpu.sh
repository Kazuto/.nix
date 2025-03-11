#!/bin/bash

sketchybar --add item cpu right \
           --set cpu  update_freq=2 \
                      icon=􀧓  \
                      icon.color=$CAT_PEACH \
                      label.padding_left=6 \
                      y_offset=1 \
                      script="$PLUGIN_DIR/cpu.sh"
