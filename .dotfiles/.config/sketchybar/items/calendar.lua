local colors = require("colors")
local icons  = require("icons")

local calendar = sbar.add("item", "calendar", {
  position = "right",
  icon = {
    string        = icons.calendar,
    color         = colors.blue,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { padding_right = 8 },
  y_offset   = 1,
  update_freq = 30,
})

calendar:subscribe({ "routine", "forced" }, function()
  sbar.exec("date '+%a %d %b %I:%M %p'", function(date)
    calendar:set({ label = date:gsub("\n", "") })
  end)
end)
