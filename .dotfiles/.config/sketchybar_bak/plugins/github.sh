#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/.env"

RESPONSE_FILE="/tmp/sketchybar_github_response"

# Making a GET request to the Notifications API
curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_NOTIFICATIONS_URL" -o "$RESPONSE_FILE" 
notification_count=$(jq '[.[] | select(.unread == true)] | length' "$RESPONSE_FILE")

if [[ $notification_count -ne 0 ]]; then
  sketchybar --set $NAME icon.color=$CAT_RED label.drawing=on label="$notification_count"
else
  sketchybar --set $NAME icon.color=$CAT_BLUE label.drawing=off
fi

case "$SENDER" in
    "mouse.entered")
        sketchybar --set "$NAME" popup.drawing=on
        ;;
    "mouse.exited"|"mouse.exited.global")
        sketchybar --set "$NAME" popup.drawing=off
        ;;
esac
