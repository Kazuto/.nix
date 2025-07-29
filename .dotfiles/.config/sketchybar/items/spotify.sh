SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"
POPUP_SCRIPT="sketchybar -m --set \$NAME popup.drawing=toggle"

sketchybar --add event spotify_change $SPOTIFY_EVENT \
  --add item spotify.name center \
  --set spotify.name click_script="$POPUP_SCRIPT" \
  popup.horizontal=on \
  popup.align=center \
  icon=󰓇 \
  icon.color="$CAT_GREEN" \
  icon.padding_left=8 \
  icon.padding_right=6 \
  label.padding_right=8 \
  label="Nothing Playing" \
  popup.background.corner_radius=10 \
  popup.background.color="$CAT_BASE" \
  popup.background.border_width=1 \
  popup.background.border_color="$CAT_SURFACE1"

sketchybar --add item spotify.back popup.spotify.name \
  --set spotify.back icon=􀊎 \
  icon.padding_left=5 \
  icon.padding_right=5 \
  script="$PLUGIN_DIR/spotify.sh" \
  label.drawing=off \
  background.drawing=off \
  --subscribe spotify.back mouse.clicked

sketchybar --add item spotify.play popup.spotify.name \
  --set spotify.play icon=􀊔 \
  icon.padding_left=5 \
  icon.padding_right=5 \
  updates=on \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/spotify.sh" \
  --subscribe spotify.back mouse.clicked

sketchybar --add item spotify.next popup.spotify.name \
  --set spotify.next icon=􀊐 \
  icon.padding_left=5 \
  icon.padding_right=10 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/spotify.sh" \
  --subscribe spotify.back mouse.clicked

sketchybar --add item spotify.shuffle popup.spotify.name \
  --set spotify.shuffle icon=􀊝 \
  icon.highlight_color=0xff1DB954 \
  icon.padding_left=5 \
  icon.padding_right=5 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/spotify.sh" \
  --subscribe spotify.back mouse.clicked

sketchybar --add item spotify.repeat popup.spotify.name \
  --set spotify.repeat icon=􀊞 \
  icon.highlight_color=0xff1DB954 \
  icon.padding_left=5 \
  icon.padding_right=5 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/spotify.sh" \
  --subscribe spotify.repeat mouse.clicked
