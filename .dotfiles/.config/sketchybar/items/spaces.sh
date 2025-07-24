#!/bin/bash

sketchybar --add event aerospace_workspace_change

for mid in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $mid); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      display="$mid"
      icon.padding_left=10
      label.padding_right=20
      label.y_offset=-1
      label.font="sketchybar-app-font:Regular:16.0"
      script="$PLUGIN_DIR/space.sh $sid"
    )

    sketchybar --add space space.$sid left \
      --set space.$sid "${space[@]}" \
      click_script="aerospace workspace $sid" \
      --subscribe space.$sid aerospace_workspace_change
  done
done

sketchybar --add item space_separator left \
  --set space_separator icon="􀆊" \
  icon.color=$CAT_TEXT \
  icon.padding_left=2 \
  icon.padding_right=2 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  --subscribe space_separator space_windows_change
