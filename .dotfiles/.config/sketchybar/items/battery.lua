-- Battery status item for sketchybar
-- Shows battery percentage and charging state with appropriate icons

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local system = require("utils.system")

-- Create battery item
local battery = sbar.add("item", "battery", {
  position = "right",
  icon = {
    string = icons.battery._100,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    color = colors.battery_icon,
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    string = "100%",
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    color = colors.item.text,
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
    corner_radius = 6,
    height = 24,
  },
  update_freq = settings.update_freq.battery,
  y_offset = settings.y_offset,
})

-- Function to get appropriate battery icon based on level and charging state
local function get_battery_icon(percentage, charging)
  if charging then
    return icons.battery.charging
  end
  
  if percentage >= 90 then
    return icons.battery._100
  elseif percentage >= 60 then
    return icons.battery._75
  elseif percentage >= 30 then
    return icons.battery._50
  elseif percentage >= 10 then
    return icons.battery._25
  else
    return icons.battery._0
  end
end

-- Function to get battery color based on level and charging state
local function get_battery_color(percentage, charging)
  if charging then
    return colors.catppuccin.mocha.green
  end
  
  if percentage >= 30 then
    return colors.catppuccin.mocha.green
  elseif percentage >= 15 then
    return colors.catppuccin.mocha.yellow
  else
    return colors.catppuccin.mocha.red
  end
end

-- Update battery status
local function update_battery()
  local battery_info = system.get_battery_info()
  
  if not battery_info or battery_info.percentage == 0 then
    -- Hide battery item if no battery info available (desktop Mac)
    battery:set({ drawing = false })
    return
  end
  
  local percentage = battery_info.percentage
  local charging = battery_info.charging
  
  local icon = get_battery_icon(percentage, charging)
  local color = get_battery_color(percentage, charging)
  local label = string.format("%d%%", percentage)
  
  battery:set({
    drawing = true,
    icon = {
      string = icon,
      color = color,
    },
    label = {
      string = label,
    },
  })
end

-- Subscribe to power events
battery:subscribe("power_source_change", update_battery)
battery:subscribe("system_woke", update_battery)

-- Initial update
update_battery()

-- Export for external access
return {
  item = battery,
  update = update_battery,
}