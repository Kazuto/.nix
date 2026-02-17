local colors = require("colors")
local icons  = require("icons")

local media = sbar.add("item", "media", {
  position = "center",
  icon = {
    string        = icons.spotify,
    color         = colors.green,
    padding_left  = 0,
    padding_right = 6,
  },
  label = {
    max_chars = 60,
  },
  scroll_texts = true,
  background   = { drawing = false },
  y_offset     = 1,
})

media:subscribe("media_change", function(env)
  sbar.exec("echo '" .. env.INFO .. "' | jq -r '.state'", function(state)
    sbar.exec("echo '" .. env.INFO .. "' | jq -r '.title + \" - \" + .artist'", function(info)
      state = state:gsub("\n", "")
      info  = info:gsub("\n", "")
      if state == "playing" then
        media:set({ label = info, drawing = true })
      else
        media:set({ label = info .. " [Paused]", drawing = true })
      end
    end)
  end)
end)
