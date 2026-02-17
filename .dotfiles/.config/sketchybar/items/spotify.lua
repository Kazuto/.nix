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

spotify:subscribe("mouse.entered", function()
  spotify:set({ popup = { drawing = true } })
end)

spotify:subscribe("mouse.exited", function()
  spotify:set({ popup = { drawing = false } })
end)

spotify:subscribe("mouse.exited.global", function()
  spotify:set({ popup = { drawing = false } })
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

  -- Write INFO to temp file to avoid shell quoting issues with JSON
  local tmp = "/tmp/sketchybar_spotify_info.json"
  local f = io.open(tmp, "w")
  if not f then return end
  f:write(info)
  f:close()

  sbar.exec("jq -r '.\"Player State\"' " .. tmp, function(state)
    state = (state:gsub("%s+$", ""))
    if state == "Playing" then
      sbar.exec("jq -r '[.Name, .Artist] | @tsv' " .. tmp, function(result)
        result = (result:gsub("%s+$", ""))
        local track, artist = result:match("^(.-)\t(.*)$")
        if not track then track = result; artist = "" end
        track  = track:sub(1, 20)
        artist = artist:sub(1, 20)
        local display = artist ~= "" and (track .. " - " .. artist) or track
        spotify:set({ label = display, drawing = true })
        spotify_play:set({ icon = { string = icons.pause } })

        sbar.exec("osascript -e 'tell application \"Spotify\" to get shuffling'", function(shuf)
          spotify_shuffle:set({ icon = { highlight = (shuf:gsub("%s+", "")) == "true" } })
        end)
        sbar.exec("osascript -e 'tell application \"Spotify\" to get repeating'", function(rep)
          spotify_repeat:set({ icon = { highlight = (rep:gsub("%s+", "")) == "true" } })
        end)
      end)
    else
      spotify:set({ popup = { drawing = false } })
      spotify_play:set({ icon = { string = icons.play } })
    end
  end)
end

spotify_play:subscribe("spotify_change", update)

-- Query current state on startup (spotify_change only fires on state *changes*)
sbar.exec([[
  osascript -e '
    if application "Spotify" is running then
      tell application "Spotify"
        set playerState to player state as string
        if playerState is "playing" then
          set trackName to name of current track
          set trackArtist to artist of current track
          return trackName & "\t" & trackArtist
        end if
      end tell
    end if
    return ""
  '
]], function(result)
  result = (result:gsub("%s+$", ""))
  if result ~= "" then
    local track, artist = result:match("^(.-)\t(.*)$")
    if track then
      track  = track:sub(1, 20)
      artist = (artist or ""):sub(1, 20)
      local display = artist ~= "" and (track .. " - " .. artist) or track
      spotify:set({ label = display, drawing = true })
      spotify_play:set({ icon = { string = icons.pause } })
    end
  end
end)

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
    local current = (result:gsub("%s+", "")) == "true"
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
    local current = (result:gsub("%s+", "")) == "true"
    spotify_repeat:set({ icon = { highlight = not current } })
    if current then
      sbar.exec("osascript -e 'tell application \"Spotify\" to set repeating to false'")
    else
      sbar.exec("osascript -e 'tell application \"Spotify\" to set repeating to true'")
    end
  end)
end)
