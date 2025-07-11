#!/bin/bash

source "$CONFIG_DIR/colors.sh"
JSON_FILE="/tmp/logitech_battery_$1.json"

if [ "$1" = "ED9B3216" ]; then
  DEVICE_ICON="􀇳"
else
  DEVICE_ICON="􀺣"
fi

__update() {
  # Use JSON file for sketchybar update
  PERCENTAGE=$(jq '.percentage' "$JSON_FILE")
  ICON=$(jq -r '.icon' "$JSON_FILE")
  CHARGING=$(jq -r '.charging' "$JSON_FILE")
  COLOR=$(jq -r '.color' "$JSON_FILE")

  if [ "$CHARGING" = true ]; then
    sketchybar --set "$NAME" icon="$DEVICE_ICON" label="$ICON"
  else
    sketchybar --set "$NAME" icon="$DEVICE_ICON " label="$PERCENTAGE%" label.color="$COLOR"
  fi
}

__update

# Capture solaar output directly into a variable
SOLLAAR_OUTPUT=$(/Users/kazuto/.pyenv/shims/solaar show "$1")

# Extract the line containing Battery:
BATTERY_LINE=$(echo "$SOLLAAR_OUTPUT" | grep "Battery:" | head -1)

# Extract percentage number before '%'
PERCENTAGE=$(echo "$BATTERY_LINE" | sed -n 's/.*Battery: *\([0-9][0-9]*\)%.*/\1/p')

# Determine charging status
if echo "$BATTERY_LINE" | grep -q "RECHARGING"; then
  CHARGING=true
else
  CHARGING=false
fi

# Exit if no percentage found
[ -z "$PERCENTAGE" ] && exit 0

# Select icon
case $PERCENTAGE in
9[0-9] | 100) ICON="􀛨" COLOR="$CAT_TEXT" ;; # Full
[6-8][0-9]) ICON="􀺸" COLOR="$CAT_TEXT" ;;   # High
[3-5][0-9]) ICON="􀺶" COLOR="$CAT_YELLOW" ;; # Medium
[1-2][0-9]) ICON="􀛩" COLOR="$CAT_PEACH" ;;  # Low
*) ICON="􀛪" COLOR="$CAT_RED" ;;             # Very low
esac

# Override icon if charging
[ "$CHARGING" = true ] && ICON="􀢋"
# Save to JSON
cat >"$JSON_FILE" <<EOF
{
  "percentage": $PERCENTAGE,
  "charging": $CHARGING,
  "icon": "$ICON",
  "color": "$COLOR",

  "device": "$1"
}
EOF

__update
