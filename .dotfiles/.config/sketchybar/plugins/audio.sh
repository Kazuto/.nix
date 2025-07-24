#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

VOLUME=0

if [ "$SENDER" = "volume_change" ]; then
  VOLUME=$INFO
fi

audio_device="$(SwitchAudioSource -c)"

if [[ "$audio_device" == *"Steinberg"* ]]; then
  sketchybar -m --set "$NAME" icon="" label="$audio_device"
fi

if [[ "$audio_device" == *"Speakers"* ]]; then
  sketchybar -m --set "$NAME" icon="󰓃" label="$audio_device ($VOLUME%)"
fi

case "$SENDER" in
    "mouse.entered")
        sketchybar --set "$NAME" popup.drawing=on
        ;;
    "mouse.exited"|"mouse.exited.global")
        sketchybar --set "$NAME" popup.drawing=off
        ;;
esac


