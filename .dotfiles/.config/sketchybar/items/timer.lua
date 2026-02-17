local colors = require("colors")
local icons  = require("icons")

local SOUNDS_PATH = "/System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/"
local COUNTDOWN_PID_FILE = "/tmp/sketchybar_timer_pid"
local DEFAULT_DURATION = 1500 -- 25 minutes

local timer = sbar.add("item", "timer", {
  position = "right",
  icon = {
    string        = icons.timer,
    color         = colors.yellow,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { string = "No Timer", padding_right = 8 },
  y_offset = 1,
  popup = {
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

local presets = { 5, 10, 25 }
for _, minutes in ipairs(presets) do
  local preset = sbar.add("item", "timer." .. minutes, {
    position      = "popup." .. timer.name,
    label         = { string = minutes .. " Minutes" },
    padding_left  = 16,
    padding_right = 16,
    background    = { drawing = false },
  })

  preset:subscribe("mouse.clicked", function()
    local seconds = minutes * 60
    -- Stop any existing timer
    sbar.exec(string.format([[
      if [ -f "%s" ]; then
        PID=$(cat "%s")
        kill "$PID" 2>/dev/null
        rm -f "%s"
      fi
    ]], COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE))

    -- Start new countdown
    sbar.exec(string.format([[
      (
        time_left=%d
        while [ "$time_left" -gt 0 ]; do
          minutes=$((time_left / 60))
          secs=$((time_left %% 60))
          sketchybar --set timer label="$(printf "%%02d:%%02d" "$minutes" "$secs")"
          sleep 1
          time_left=$((time_left - 1))
        done
        afplay "%sGuideSuccess.aiff"
        sketchybar --set timer label="Done"
      ) &
      echo $! > "%s"
      afplay "%sTrackingOn.aiff"
    ]], seconds, SOUNDS_PATH, COUNTDOWN_PID_FILE, SOUNDS_PATH))

    timer:set({ popup = { drawing = false } })
  end)
end

timer:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "left" then
    -- Start default 25 min timer
    sbar.exec(string.format([[
      if [ -f "%s" ]; then
        PID=$(cat "%s")
        kill "$PID" 2>/dev/null
        rm -f "%s"
      fi
      (
        time_left=%d
        while [ "$time_left" -gt 0 ]; do
          minutes=$((time_left / 60))
          secs=$((time_left %% 60))
          sketchybar --set timer label="$(printf "%%02d:%%02d" "$minutes" "$secs")"
          sleep 1
          time_left=$((time_left - 1))
        done
        afplay "%sGuideSuccess.aiff"
        sketchybar --set timer label="Done"
      ) &
      echo $! > "%s"
      afplay "%sTrackingOn.aiff"
    ]], COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE,
        DEFAULT_DURATION, SOUNDS_PATH, COUNTDOWN_PID_FILE, SOUNDS_PATH))
  elseif env.BUTTON == "right" then
    -- Stop timer
    sbar.exec(string.format([[
      if [ -f "%s" ]; then
        PID=$(cat "%s")
        kill "$PID" 2>/dev/null
        rm -f "%s"
      fi
      afplay "%sTrackingOff.aiff"
    ]], COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE, SOUNDS_PATH))
    timer:set({ label = "No Timer" })
  end
end)

timer:subscribe("mouse.entered", function()
  timer:set({ popup = { drawing = true } })
end)

timer:subscribe("mouse.exited", function()
  timer:set({ popup = { drawing = false } })
end)

timer:subscribe("mouse.exited.global", function()
  timer:set({ popup = { drawing = false } })
end)
