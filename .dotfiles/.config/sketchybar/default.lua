local colors = require("colors")

sbar.default({
  icon = {
    font          = "JetBrainsMono Nerd Font Propo:Semibold:13.0",
    color         = colors.text,
  },
  label = {
    font          = "SF Pro:Medium:13.0",
    color         = colors.text,
  },
  background = {
    corner_radius = 10,
    height        = 26,
    color         = 0x15000000,
  },
  padding_left  = 4,
  padding_right = 4,
})
