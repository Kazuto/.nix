local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Volume item configuration
local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    color = colors.catppuccin.mocha.blue,
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    font = {
      family = settings.fonts.numbers.family,
      style = settings.fonts.numbers.style,
      size = settings.fonts.numbers.size,
    },
    color = colors.item.text,
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
    corner_radius = 6,
    height = 24,
  },
  y_offset = settings.y_offset,
})

-- Function to get volume icon based on level
local function get_volume_icon(volume_level)
  if volume_level >= 60 then
    return icons.volume._100
  elseif volume_level >= 30 then
    return icons.volume._66
  elseif volume_level >= 10 then
    return icons.volume._33
  elseif volume_level > 0 then
    return icons.volume._10
  else
    return icons.volume._0
  end
end

-- Function to get current volume level using system commands
local function get_volume_level()
  local handle = io.popen("osascript -e 'output volume of (get volume settings)'")
  if not handle then
    return 50 -- Fallback volume level
  end
  
  local result = handle:read("*a")
  handle:close()
  
  -- Handle "missing value" case (e.g., external audio interfaces)
  if result:match("missing value") then
    return 50 -- Default volume when hardware-controlled
  end
  
  local cleaned_result = result:gsub("%s+", "")
  local volume_level = tonumber(cleaned_result)
  return volume_level or 50
end

-- Function to set volume level
local function set_volume(level)
  -- Clamp volume level between 0 and 100
  level = math.max(0, math.min(100, level))
  
  -- Use osascript to set volume
  local command = string.format("osascript -e 'set volume output volume %d'", level)
  os.execute(command)
  
  -- Update display immediately
  local icon = get_volume_icon(level)
  volume:set({
    icon = {
      string = icon,
    },
    label = {
      string = level .. "%",
    },
  })
end

-- Function to update volume display
local function update_volume()
  local volume_level = get_volume_level()
  local icon = get_volume_icon(volume_level)
  
  volume:set({
    icon = {
      string = icon,
    },
    label = {
      string = volume_level .. "%",
    },
  })
end

-- Subscribe to volume change events
volume:subscribe("volume_change", function(env)
  -- The volume_change event supplies volume level in INFO variable
  local volume_level = tonumber(env.INFO) or get_volume_level()
  local icon = get_volume_icon(volume_level)
  
  volume:set({
    icon = {
      string = icon,
    },
    label = {
      string = volume_level .. "%",
    },
  })
end)

-- Add click handlers for volume control
volume:subscribe("mouse.clicked", function(env)
  local current_volume = get_volume_level()
  
  if env.BUTTON == "left" then
    -- Left click: increase volume by 10%
    set_volume(current_volume + 10)
  elseif env.BUTTON == "right" then
    -- Right click: decrease volume by 10%
    set_volume(current_volume - 10)
  elseif env.BUTTON == "middle" then
    -- Middle click: toggle mute (set to 0 or restore to 50%)
    if current_volume > 0 then
      set_volume(0)
    else
      set_volume(50)
    end
  end
end)

-- Subscribe to system volume change events for real-time updates
volume:subscribe("system_woke", function()
  update_volume()
end)

-- Initial volume update
update_volume()

-- Export for external access
return {
  item = volume,
  update = update_volume,
  set_volume = set_volume,
}