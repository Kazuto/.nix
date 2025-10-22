-- CPU usage monitoring item for sketchybar
-- Displays current CPU usage percentage with proper styling

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local system = require("utils.system")

-- Create CPU item
local cpu = sbar.add("item", "cpu", {
  position = "right",
  icon = {
    string = icons.cpu,
    color = colors.catppuccin.mocha.peach,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    string = "0%",
    color = colors.item.text,
    font = {
      family = settings.fonts.numbers.family,
      style = settings.fonts.numbers.style,
      size = settings.fonts.numbers.size,
    },
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
  },
  y_offset = settings.y_offset,
  update_freq = settings.update_freq.cpu,
})

-- Update CPU usage display
local function update_cpu()
  local cpu_info = system.get_cpu_usage()
  if cpu_info then
    cpu:set({
      label = {
        string = cpu_info.total .. "%"
      }
    })
  else
    -- Fallback if system call fails
    cpu:set({
      label = {
        string = "N/A"
      }
    })
  end
end

-- Subscribe to routine event for periodic updates
cpu:subscribe("routine", function()
  update_cpu()
end)

-- Subscribe to forced update event
cpu:subscribe("forced", function()
  update_cpu()
end)

-- Initial update
update_cpu()

-- Export for external access
return {
  item = cpu,
  update = update_cpu
}