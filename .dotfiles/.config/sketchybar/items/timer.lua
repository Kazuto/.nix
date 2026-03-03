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

local function start_timer(seconds)
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
      seconds, SOUNDS_PATH, COUNTDOWN_PID_FILE, SOUNDS_PATH))
end

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
    start_timer(minutes * 60)
    timer:set({ popup = { drawing = false } })
  end)
end

timer:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "left" then
    start_timer(DEFAULT_DURATION)
  elseif env.BUTTON == "right" then
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

-- After wake the countdown shell process will be dead; detect this and reset the label
timer:subscribe("system_woke", function()
  sbar.exec(string.format([[
    if [ -f "%s" ]; then
      PID=$(cat "%s")
      if ! kill -0 "$PID" 2>/dev/null; then
        rm -f "%s"
        sketchybar --set timer label="No Timer"
      fi
    fi
  ]], COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE, COUNTDOWN_PID_FILE))
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
