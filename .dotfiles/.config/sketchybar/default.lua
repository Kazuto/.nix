local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.icon.font,
      style = settings.icon.style,
      size = settings.icon.size,
    },
    color = colors.catppuccin.mocha.text,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  label = {
    font = {
      family = settings.label.font,
      style = settings.label.style,
      size = settings.label.size,
    },
    color = colors.catppuccin.mocha.text,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height = 26,
    corner_radius = 10,
    border_width = 0,
    color = "0x15000000", -- Semi-transparent background to match bash config
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 9,
      border_color = colors.catppuccin.mocha.crust,
      color = colors.catppuccin.mocha.base,
      shadow = { drawing = true },
    },
    blur_radius = 20,
  },
  padding_left = 4,
  padding_right = 4,
})
