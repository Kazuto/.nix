-- Timer functionality item for sketchybar
-- Provides timer/stopwatch functionality with state management

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Timer state management
local timer_state = {
  running = false,
  paused = false,
  time_left = 0,
  original_duration = 0,
  timer_process = nil,
}

-- Default timer duration (25 minutes in seconds)
local DEFAULT_DURATION = 1500

-- Sound paths for timer events
local SOUNDS_PATH = "/System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/"

-- Timer display formatting function
local function format_time(seconds)
  if seconds <= 0 then
    return "00:00"
  end
  
  local minutes = math.floor(seconds / 60)
  local secs = seconds % 60
  return string.format("%02d:%02d", minutes, secs)
end

-- Create timer item
local timer = sbar.add("item", "timer", {
  position = "right",
  icon = {
    string = icons.timer,
    color = colors.catppuccin.mocha.yellow,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    string = "No Timer",
    color = colors.item.text,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
  },
  y_offset = settings.y_offset,
  popup = {
    background = {
      corner_radius = settings.popup.corner_radius,
      color = colors.catppuccin.mocha.base,
      border_width = settings.popup.border_width,
      border_color = colors.catppuccin.mocha.surface1,
    },
  },
})

-- Timer control functions
local function start_timer(duration)
  duration = duration or DEFAULT_DURATION
  
  -- Stop any existing timer
  stop_timer()
  
  -- Set timer state
  timer_state.running = true
  timer_state.paused = false
  timer_state.time_left = duration
  timer_state.original_duration = duration
  
  -- Play start sound
  os.execute("afplay '" .. SOUNDS_PATH .. "TrackingOn.aiff' &")
  
  -- Update display immediately
  timer:set({
    label = { string = format_time(timer_state.time_left) }
  })
end

local function pause_timer()
  if timer_state.running and not timer_state.paused then
    timer_state.paused = true
    
    timer:set({
      label = { string = format_time(timer_state.time_left) .. " (Paused)" }
    })
  end
end

local function resume_timer()
  if timer_state.paused and timer_state.time_left > 0 then
    timer_state.paused = false
    
    timer:set({
      label = { string = format_time(timer_state.time_left) }
    })
  end
end

function stop_timer()
  if timer_state.running or timer_state.paused then
    -- Reset timer state
    timer_state.running = false
    timer_state.paused = false
    timer_state.time_left = 0
    timer_state.original_duration = 0
    
    -- Play stop sound
    os.execute("afplay '" .. SOUNDS_PATH .. "TrackingOff.aiff' &")
    
    -- Update display
    timer:set({
      label = { string = "No Timer" }
    })
  end
end

function reset_timer()
  if timer_state.original_duration > 0 then
    stop_timer()
    start_timer(timer_state.original_duration)
  end
end

-- Create popup menu items for quick timer selection
local timer_5 = sbar.add("item", "timer.5", {
  position = "popup.timer",
  label = {
    string = "5 Minutes",
    color = colors.item.text,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    padding_left = 16,
    padding_right = 16,
  },
  background = {
    drawing = false,
  },
})

local timer_10 = sbar.add("item", "timer.10", {
  position = "popup.timer",
  label = {
    string = "10 Minutes",
    color = colors.item.text,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    padding_left = 16,
    padding_right = 16,
  },
  background = {
    drawing = false,
  },
})

local timer_25 = sbar.add("item", "timer.25", {
  position = "popup.timer",
  label = {
    string = "25 Minutes",
    color = colors.item.text,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    padding_left = 16,
    padding_right = 16,
  },
  background = {
    drawing = false,
  },
})

-- Update timer display
local function update_timer_display()
  if timer_state.running and not timer_state.paused then
    if timer_state.time_left > 0 then
      timer:set({
        label = { string = format_time(timer_state.time_left) }
      })
      timer_state.time_left = timer_state.time_left - 1
    else
      -- Timer completed
      timer_state.running = false
      timer:set({
        label = { string = "Done" }
      })
      -- Play completion sound
      os.execute("afplay '" .. SOUNDS_PATH .. "GuideSuccess.aiff' &")
    end
  elseif timer_state.paused then
    -- Keep showing paused state
    timer:set({
      label = { string = format_time(timer_state.time_left) .. " (Paused)" }
    })
  end
end

-- Click handlers for timer controls
timer:subscribe("mouse.clicked", function(env)
  local button = env.BUTTON
  if button == "left" then
    if timer_state.running and not timer_state.paused then
      pause_timer()
    elseif timer_state.paused then
      resume_timer()
    else
      start_timer(DEFAULT_DURATION)
    end
  elseif button == "right" then
    stop_timer()
  end
end)

-- Popup menu handlers
timer:subscribe("mouse.entered", function()
  timer:set({ popup = { drawing = true } })
end)

timer:subscribe("mouse.exited", function()
  timer:set({ popup = { drawing = false } })
end)

timer:subscribe("mouse.exited.global", function()
  timer:set({ popup = { drawing = false } })
end)

-- Popup menu item click handlers
timer_5:subscribe("mouse.clicked", function()
  start_timer(5 * 60) -- 5 minutes in seconds
  timer:set({ popup = { drawing = false } })
end)

timer_10:subscribe("mouse.clicked", function()
  start_timer(10 * 60) -- 10 minutes in seconds
  timer:set({ popup = { drawing = false } })
end)

timer_25:subscribe("mouse.clicked", function()
  start_timer(25 * 60) -- 25 minutes in seconds
  timer:set({ popup = { drawing = false } })
end)

-- Subscribe to routine event for periodic updates (every second)
timer:subscribe("routine", function()
  update_timer_display()
end)

-- Subscribe to forced update event
timer:subscribe("forced", function()
  update_timer_display()
end)

-- Export timer functions and state for external access
return {
  item = timer,
  start = start_timer,
  pause = pause_timer,
  resume = resume_timer,
  stop = stop_timer,
  reset = reset_timer,
  update = update_timer_display,
  state = timer_state,
  format_time = format_time,
}