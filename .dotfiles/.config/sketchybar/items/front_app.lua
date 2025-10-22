-- Front application display item
-- Shows the currently focused application with icon and name

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local icon_map = require("utils.icon_map")

-- Create the front_app item positioned in center
local front_app = sbar.add("item", "front_app", {
  position = "left",
  icon = {
    font = {
      family = settings.fonts.app_icons.family,
      style = settings.fonts.app_icons.style,
      size = settings.fonts.app_icons.size,
    },
    color = colors.catppuccin.mocha.base,
    padding_left = 10,
    padding_right = 5,
  },
  label = {
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    color = colors.catppuccin.mocha.base,
    padding_right = 10,
    shadow = { drawing = false },
  },
  background = {
    color = colors.catppuccin.mocha.peach,
    corner_radius = 6,
    height = 24,
  },
  y_offset = settings.y_offset,
})

-- Function to update front app display
local function update_front_app(app_name)
  if not app_name or app_name == "" then
    front_app:set({
      icon = { string = icons.default_app },
      label = { string = "Unknown" },
    })
    return
  end
  
  -- Get the appropriate icon for the application
  local app_icon = icon_map.get_icon(app_name)
  
  -- Use default app icon if no specific icon found
  if app_icon == ":default:" then
    app_icon = icons.default_app
  end
  
  -- Update the item with new app info
  front_app:set({
    icon = { string = app_icon },
    label = { string = app_name },
  })
end

-- Subscribe to front_app_switched event
front_app:subscribe("front_app_switched", function(env)
  local app_name = env.INFO
  update_front_app(app_name)
end)

-- Get initial front app on startup
sbar.exec("osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'", function(result)
  local app_name = result:gsub("%s+$", "") -- trim whitespace
  update_front_app(app_name)
end)

-- Export for external access
return {
  item = front_app,
  update = update_front_app,
}