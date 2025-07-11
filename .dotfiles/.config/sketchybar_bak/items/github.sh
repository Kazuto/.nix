#!/bin/bash

POPUP_SCRIPT="sketchybar -m --set \$NAME popup.drawing=toggle"

sketchybar --add item github right \
  --set github icon=":git_hub:" \
  click_script="$POPUP_SCRIPT" \
  icon.font="sketchybar-app-font:Regular:13.0" \
  icon.color=$CAT_LAVENDER \
  icon.padding_left=8 \
  icon.padding_right=6 \
  label.padding_right=8 \
  update_freq=60 \
  script="$PLUGIN_DIR/github.sh" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1" \
  popup.align=right \
  --subscribe github

RESPONSE_FILE="/tmp/sketchybar_github_response"

check_github_notifications() {
  while true; do
    if [[ -f "$RESPONSE_FILE" && -s "$RESPONSE_FILE" ]]; then
      jq -c '.[]' "$RESPONSE_FILE" | while read -r notification; do
        id=$(echo "$notification" | jq -r '.id')
        repo_name=$(echo "$notification" | jq -r '.repository.full_name')
        subject_title=$(echo "$notification" | jq -r '.subject.title')
        url=$(echo "$notification" | jq -r '.subject.html_url')

        sketchybar --add item "github.${id}" popup.github \
          --set "github.${id}" label="${repo_name}: ${subject_title}" \
          click_script="open $url; sketchybar -m --set github popup.drawing=off" \
          padding_left=16 \
          padding_right=16 \
          background.drawing=off
      done
    fi

    sleep 5
  done
}

# Start background process
check_github_notifications &
