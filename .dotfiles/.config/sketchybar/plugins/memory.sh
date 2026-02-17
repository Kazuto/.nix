#!/bin/bash

TOTAL_MEM=$(sysctl -n hw.memsize)
TOTAL_MEM_MB=$((TOTAL_MEM / 1024 / 1024))

USED_MEM_PAGES=$(vm_stat | awk '/Pages active/ {gsub(/\./,"",$3); print $3}')
WIRED_MEM_PAGES=$(vm_stat | awk '/Pages wired/ {gsub(/\./,"",$4); print $4}')
COMPRESSED_MEM_PAGES=$(vm_stat | awk '/Pages occupied by compressor/ {gsub(/\./,"",$5); print $5}')

PAGE_SIZE=$(sysctl -n hw.pagesize)
USED_MEM_BYTES=$(( (USED_MEM_PAGES + WIRED_MEM_PAGES + COMPRESSED_MEM_PAGES) * PAGE_SIZE ))
MEM_PERCENT=$((USED_MEM_BYTES / 1024 / 1024 * 100 / TOTAL_MEM_MB))

USED_GB=$(echo "$USED_MEM_BYTES" | awk '{printf "%.2f", $1 / 1024 / 1024 / 1024}')
TOTAL_GB=$(echo "$TOTAL_MEM" | awk '{printf "%.0f", $1 / 1024 / 1024 / 1024}')
ACTIVE_MB=$(( USED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))
WIRED_MB=$(( WIRED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))
COMPRESSED_MB=$(( COMPRESSED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))

sketchybar --set $NAME label="${MEM_PERCENT}%"

sketchybar --set memory.usage label="${USED_GB} / ${TOTAL_GB}GB" \
           --set memory.active label="Active: ${ACTIVE_MB}MB" \
           --set memory.wired label="Wired: ${WIRED_MB}MB" \
           --set memory.compressed label="Compressed: ${COMPRESSED_MB}MB"

case "$SENDER" in
"mouse.entered")
  sketchybar --set "$NAME" popup.drawing=on
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set "$NAME" popup.drawing=off
  ;;
esac
