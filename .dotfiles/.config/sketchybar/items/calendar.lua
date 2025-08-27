local icons = require("icons")
local colors = require("colors")

local calendar = sbar.add("item", {
  icon = {
    string = icons.calendar,
    color = colors.catppuccin.mocha.blue,
    padding = {
      left = 8,
      right = 5,
    },
  },
  label = {
    padding = {
      right = 8,
    },
  },
  position = "right",
  update_freq = 30,
})

local function update()
  local date = os.date("%A, %d.%m.%Y %I:%M %p")

  calendar:set({ label = date })
end

calendar:subscribe("routine", update)
calendar:subscribe("forced", update)
