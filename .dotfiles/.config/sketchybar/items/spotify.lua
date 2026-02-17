local colors = require("colors")
local icons  = require("icons")

local SPOTIFY_EVENT = "com.spotify.client.PlaybackStateChanged"

sbar.add("event", "spotify_change", SPOTIFY_EVENT)

local spotify = sbar.add("item", "spotify.name", {
  position = "center",
  icon = {
    string        = icons.spotify,
    color         = colors.green,
    padding_left  = 8,
    padding_right = 6,
  },
  label = {
    string        = "Nothing Playing",
    padding_right = 8,
  },
  popup = {
    horizontal = true,
    align      = "center",
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

spotify:subscribe("mouse.clicked", function()
  sbar.set("spotify.name", { popup = { drawing = "toggle" } })
end)

local spotify_back = sbar.add("item", "spotify.back", {
  position      = "popup." .. spotify.name,
  icon          = { string = icons.back, padding_left = 5, padding_right = 5 },
  padding_left  = 16,
  label         = { drawing = false },
  background    = { drawing = false },
})

local spotify_play = sbar.add("item", "spotify.play", {
  position   = "popup." .. spotify.name,
  icon       = { string = icons.play, padding_left = 5, padding_right = 5 },
  updates    = true,
  label      = { drawing = false },
  background = { drawing = false },
})

local spotify_next = sbar.add("item", "spotify.next", {
  position   = "popup." .. spotify.name,
  icon       = { string = icons.next, padding_left = 5, padding_right = 10 },
  label      = { drawing = false },
  background = { drawing = false },
})

local spotify_shuffle = sbar.add("item", "spotify.shuffle", {
  position   = "popup." .. spotify.name,
  icon       = { string = icons.shuffle, highlight_color = 0xff1DB954, padding_left = 5, padding_right = 5 },
  label      = { drawing = false },
  background = { drawing = false },
})

local spotify_repeat = sbar.add("item", "spotify.repeat", {
  position      = "popup." .. spotify.name,
  icon          = { string = icons.repeating, highlight_color = 0xff1DB954, padding_left = 5, padding_right = 5 },
  padding_right = 16,
  label         = { drawing = false },
  background    = { drawing = false },
})

local function update(env)
  local info = env.INFO
  if info == nil or info == "" then return end

  sbar.exec("echo '" .. info .. "' | jq -r '.\"Player State\"'", function(state)
    state = state:gsub("\n", "")
    if state == "Playing" then
      sbar.exec("echo '" .. info .. "' | jq -r '.Name'", function(track)
        sbar.exec("echo '" .. info .. "' | jq -r '.Artist'", function(artist)
          track  = track:gsub("\n", ""):sub(1, 20)
          artist = artist:gsub("\n", ""):sub(1, 20)
          local display = artist ~= "" and (track .. " - " .. artist) or track
          spotify:set({ label = display, drawing = true })
          spotify_play:set({ icon = { string = icons.pause } })

          sbar.exec("osascript -e 'tell application \"Spotify\" to get shuffling'", function(shuf)
            spotify_shuffle:set({ icon = { highlight = shuf:gsub("\n", "") == "true" } })
          end)
          sbar.exec("osascript -e 'tell application \"Spotify\" to get repeating'", function(rep)
            spotify_repeat:set({ icon = { highlight = rep:gsub("\n", "") == "true" } })
          end)
        end)
      end)
    else
      spotify:set({ popup = { drawing = false } })
      spotify_play:set({ icon = { string = icons.play } })
    end
  end)
end

spotify_play:subscribe("spotify_change", update)

spotify_back:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"Spotify\" to play previous track'")
end)

spotify_play:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"Spotify\" to playpause'")
end)

spotify_next:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"Spotify\" to play next track'")
end)

spotify_shuffle:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"Spotify\" to get shuffling'", function(result)
    local current = result:gsub("\n", "") == "true"
    spotify_shuffle:set({ icon = { highlight = not current } })
    if current then
      sbar.exec("osascript -e 'tell application \"Spotify\" to set shuffling to false'")
    else
      sbar.exec("osascript -e 'tell application \"Spotify\" to set shuffling to true'")
    end
  end)
end)

spotify_repeat:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'tell application \"Spotify\" to get repeating'", function(result)
    local current = result:gsub("\n", "") == "true"
    spotify_repeat:set({ icon = { highlight = not current } })
    if current then
      sbar.exec("osascript -e 'tell application \"Spotify\" to set repeating to false'")
    else
      sbar.exec("osascript -e 'tell application \"Spotify\" to set repeating to true'")
    end
  end)
end)
