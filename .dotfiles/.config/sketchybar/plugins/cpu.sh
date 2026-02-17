#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"
CPU_SYS_PERCENT="$(echo "$CPU_SYS" | awk '{printf "%.1f\n", $1*100}')"
CPU_USER_PERCENT="$(echo "$CPU_USER" | awk '{printf "%.1f\n", $1*100}')"

# Top 5 processes by CPU
TOP_PROCS=$(ps -eo pcpu,comm -r | head -6 | tail -5 | awk '{n=split($2,a,"/"); printf "%.1f%% %s\n", $1, a[n]}')

sketchybar --set $NAME label="$CPU_PERCENT%"

sketchybar --set cpu.total label="Total: ${CPU_PERCENT}% (${CORE_COUNT} threads)" \
           --set cpu.user label="User: ${CPU_USER_PERCENT}%" \
           --set cpu.sys label="System: ${CPU_SYS_PERCENT}%"

# Update top processes
i=1
echo "$TOP_PROCS" | while IFS= read -r proc; do
  sketchybar --set "cpu.top${i}" label="$proc"
  i=$((i + 1))
done

case "$SENDER" in
"mouse.entered")
  sketchybar --set "$NAME" popup.drawing=on
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set "$NAME" popup.drawing=off
  ;;
esac
