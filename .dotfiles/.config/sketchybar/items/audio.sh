#!/bin/bash

POPUP_SCRIPT="sketchybar -m --set \$NAME popup.drawing=toggle"

sketchybar -m --add item audio right \
  --set audio click_script="$POPUP_SCRIPT" \
  icon.color=$CAT_GREEN \
  icon.padding_left=8 \
  icon.padding_right=5 \
  label.padding_right=8 \
  y_offset=1 \
  script="$PLUGIN_DIR/audio.sh" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1" \
  popup.align=right \
  --subscribe audio volume_change

declare -A devices

while IFS="=" read -r id name; do
  devices["$id"]="$name"
done < <(
  SwitchAudioSource -a -f json | jq -r '
    select(
      .type == "output" and
      (.name | test("Steinberg|Speaker"; "i"))
    ) |
    "\(.id)=\(.name)"
  '
)

for id in "${!devices[@]}"; do

  name=${devices[$id]}

  if [[ "$name" == *"Steinberg"* ]]; then
    icon=""
  fi

  if [[ "$name" == *"Speakers"* ]]; then
    icon="󰓃"
  fi

  sketchybar --add item "audio.${id}" popup.audio \
    --set "audio.${id}" \
    icon="$icon" \
    label="${devices[$id]}" \
    label.padding_left=5 \
    padding_left=16 \
    padding_right=16 \
    background.drawing=off \
    click_script="SwitchAudioSource -i ${id}; sketchybar -m --set audio popup.drawing=off"
done
