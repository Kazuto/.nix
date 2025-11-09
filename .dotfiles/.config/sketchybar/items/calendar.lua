local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local calendar = sbar.add("item", {
  icon = {
    string = icons.calendar,
    color = colors.catppuccin.mocha.blue,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    color = colors.catppuccin.mocha.text,
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
    corner_radius = 10,
    height = 26,
  },
  position = "right",
  y_offset = settings.y_offset,
  update_freq = settings.update_freq.calendar,
})

local function update()
  -- Format: "Mon 22 Oct 02:30 PM" to match shell config format
  local date = os.date("%a %d %b %I:%M %p")

  calendar:set({ label = { string = date } })
end

calendar:subscribe("routine", update)
calendar:subscribe("forced", update)
