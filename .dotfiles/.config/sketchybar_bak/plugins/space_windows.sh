#!/bin/bash

for mid in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $mid); do
    apps=$(aerospace list-windows --workspace $i | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    icon_strip=" "

    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$i label="$icon_strip"
  done
done
