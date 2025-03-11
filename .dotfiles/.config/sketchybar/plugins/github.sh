#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/.env"

# Making a GET request to the Notifications API
response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" $GITHUB_NOTIFICATIONS_URL)
notification_count=$(echo "$response" | jq '[.[] | select(.unread == true)] | length')

if [[ $notification_count -ne 0 ]]; then
  sketchybar --set $NAME icon.color=$CAT_RED label.drawing=on label="$notification_count"
else
  sketchybar --set $NAME icon.color=$CAT_BLUE label.drawing=off
fi
