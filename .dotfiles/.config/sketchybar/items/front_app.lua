local colors = require("colors")

local config_dir = os.getenv("HOME") .. "/.config/sketchybar"

local front_app = sbar.add("item", "front_app", {
  position = "left",
  background = { color = colors.peach },
  icon = {
    color         = colors.base,
    font          = "sketchybar-app-font:Regular:16.0",
    padding_left  = 10,
    padding_right = 5,
  },
  label = {
    padding_right = 10,
    color         = colors.base,
    shadow        = { drawing = false },
  },
})

front_app:subscribe("front_app_switched", function(env)
  sbar.exec(config_dir .. "/plugins/icon_map_fn.sh '" .. env.INFO .. "'", function(icon)
    front_app:set({
      label = env.INFO,
      icon  = icon:gsub("\n", ""),
    })
  end)
end)
