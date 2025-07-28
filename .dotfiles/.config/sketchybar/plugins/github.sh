#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/.env"

RESPONSE_FILE="/tmp/sketchybar_github_response"
TMP_FILE=$(mktemp)

# Fetch notifications from GitHub API
curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_NOTIFICATIONS_URL" -o "$RESPONSE_FILE"

# Count unread notifications
notification_count=$(jq '[.[] | select(.unread == true)] | length' "$RESPONSE_FILE")
echo "Unread notifications: $notification_count" >&2

# Process each notification, append constructed html_url based on subject info
jq -c '.[]' "$RESPONSE_FILE" | while read -r notif; do
  subject_url=$(jq -r '.subject.url' <<<"$notif")
  subject_type=$(jq -r '.subject.type' <<<"$notif")
  repo_full_name=$(jq -r '.repository.full_name' <<<"$notif")

  # If any essential data missing, keep notification unchanged
  if [[ "$subject_url" == "null" || -z "$subject_url" || -z "$repo_full_name" ]]; then
    echo "$notif" >>"$TMP_FILE"
    continue
  fi

  # Extract notification ID from the last segment of the URL
  subject_id=${subject_url##*/}

  # Map notification type to GitHub URL path segment
  case "$subject_type" in
  PullRequest) html_path="pull" ;;
  Issue) html_path="issues" ;;
  *)
    echo "⚠️ Unknown subject type: $subject_type" >&2
    echo "$notif" >>"$TMP_FILE"
    continue
    ;;
  esac

  # Construct html_url for browser links
  html_url="https://github.com/$repo_full_name/$html_path/$subject_id"
  echo " → Constructed html_url: $html_url" >&2

  # Append html_url to the subject object
  echo "$notif" | jq --arg html_url "$html_url" '.subject.html_url = $html_url' >>"$TMP_FILE"
done

# Combine updated notifications back into a JSON array, overwrite response file
if [[ -s "$TMP_FILE" ]]; then
  jq -s . "$TMP_FILE" >"$RESPONSE_FILE"
else
  echo "⚠️ No valid notifications were processed, original file unchanged." >&2
fi

rm -f "$TMP_FILE"

# Update sketchybar based on unread notification count
if ((notification_count > 0)); then
  sketchybar --set "$NAME" icon.color="$CAT_RED" label.drawing=on label="$notification_count"
else
  sketchybar --set "$NAME" icon.color="$CAT_LAVENDER" label.drawing=off
fi

# Handle popup drawing based on mouse events
case "$SENDER" in
mouse.clicked)
  sketchybar --set "$NAME" popup.drawing=toggle
  ;;
esac
