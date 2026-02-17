#!/bin/bash

INTERFACE="en0"
PREV_FILE="/tmp/sketchybar_network_prev"

CURRENT=$(netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $4 ~ /\./ {print $7, $10; exit}')
CURRENT_IN=$(echo "$CURRENT" | awk '{print $1}')
CURRENT_OUT=$(echo "$CURRENT" | awk '{print $2}')

if [ -f "$PREV_FILE" ]; then
  PREV_IN=$(awk '{print $1}' "$PREV_FILE")
  PREV_OUT=$(awk '{print $2}' "$PREV_FILE")

  DIFF_IN=$((CURRENT_IN - PREV_IN))
  DIFF_OUT=$((CURRENT_OUT - PREV_OUT))

  # Convert to human-readable (per second, update_freq=2)
  DOWN=$(echo "$DIFF_IN" | awk '{
    v = $1 / 2
    if (v >= 1048576) printf "%.1f MB/s", v / 1048576
    else if (v >= 1024) printf "%.0f KB/s", v / 1024
    else printf "%.0f B/s", v
  }')
  UP=$(echo "$DIFF_OUT" | awk '{
    v = $1 / 2
    if (v >= 1048576) printf "%.1f MB/s", v / 1048576
    else if (v >= 1024) printf "%.0f KB/s", v / 1024
    else printf "%.0f B/s", v
  }')
else
  DOWN="0 B/s"
  UP="0 B/s"
fi

echo "$CURRENT_IN $CURRENT_OUT" > "$PREV_FILE"

IP=$(ipconfig getifaddr "$INTERFACE" 2>/dev/null || echo "N/A")

sketchybar --set $NAME label="↓${DOWN} ↑${UP}"

sketchybar --set network.interface label="Interface: ${INTERFACE}" \
           --set network.ip label="IP: ${IP}"

case "$SENDER" in
"mouse.entered")
  sketchybar --set "$NAME" popup.drawing=on
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set "$NAME" popup.drawing=off
  ;;
esac
