local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Spotify integration functionality
local spotify = {}

-- Track information retrieval using AppleScript
function spotify.get_track_info()
  local handle = io.popen('osascript -e \'tell application "System Events" to (name of processes) contains "Spotify"\'')
  local spotify_running = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  if spotify_running ~= "true" then
    return nil
  end
  
  -- Get current track information
  local info_script = [[
    tell application "Spotify"
      try
        set trackName to name of current track
        set artistName to artist of current track
        set albumName to album of current track
        set playerState to player state as string
        return trackName & "|" & artistName & "|" & albumName & "|" & playerState
      on error
        return "|||Stopped"
      end try
    end tell
  ]]
  
  local handle = io.popen('osascript -e \'' .. info_script .. '\'')
  local result = handle:read("*a")
  handle:close()
  
  if not result or result == "" then
    return nil
  end
  
  -- Remove trailing newline and split by pipe
  result = result:gsub("%s+$", "")
  
  local function split(str, delimiter)
    local parts = {}
    local pattern = "([^" .. delimiter .. "]*)" .. delimiter .. "?"
    for part in str:gmatch(pattern) do
      table.insert(parts, part)
    end
    return parts
  end
  
  local parts = split(result, "|")
  
  return {
    track = parts[1] or "",
    artist = parts[2] or "",
    album = parts[3] or "",
    state = parts[4] or "Stopped"
  }
end

-- Media control functions
function spotify.play_pause()
  os.execute('osascript -e \'tell application "Spotify" to playpause\'')
end

function spotify.next_track()
  os.execute('osascript -e \'tell application "Spotify" to play next track\'')
end

function spotify.previous_track()
  os.execute('osascript -e \'tell application "Spotify" to play previous track\'')
end

function spotify.toggle_shuffle()
  local script = [[
    tell application "Spotify"
      set currentShuffle to shuffling
      if currentShuffle is false then
        set shuffling to true
        return "true"
      else
        set shuffling to false
        return "false"
      end if
    end tell
  ]]
  
  local handle = io.popen('osascript -e \'' .. script .. '\'')
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  return result == "true"
end

function spotify.toggle_repeat()
  local script = [[
    tell application "Spotify"
      set currentRepeat to repeating
      if currentRepeat is false then
        set repeating to true
        return "true"
      else
        set repeating to false
        return "false"
      end if
    end tell
  ]]
  
  local handle = io.popen('osascript -e \'' .. script .. '\'')
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  return result == "true"
end

function spotify.get_shuffle_state()
  local handle = io.popen('osascript -e \'tell application "Spotify" to get shuffling\'')
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  return result == "true"
end

function spotify.get_repeat_state()
  local handle = io.popen('osascript -e \'tell application "Spotify" to get repeating\'')
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  return result == "true"
end

-- Get album artwork URL
function spotify.get_artwork_url()
  local script = [[
    tell application "Spotify"
      try
        return artwork url of current track
      on error
        return ""
      end try
    end tell
  ]]
  
  local handle = io.popen('osascript -e \'' .. script .. '\'')
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  return result ~= "" and result or nil
end

-- Download album artwork
function spotify.download_artwork(url, track_id)
  if not url or url == "" then
    return nil
  end
  
  -- Create cache directory if it doesn't exist
  local cache_dir = os.getenv("HOME") .. "/.cache/sketchybar/spotify"
  os.execute("mkdir -p " .. cache_dir)
  
  -- Use track ID as filename to avoid re-downloading same artwork
  local filename = cache_dir .. "/" .. (track_id or "current") .. ".jpg"
  
  -- Check if file already exists
  local file = io.open(filename, "r")
  if file then
    file:close()
    return filename
  end
  
  -- Download the artwork
  local download_cmd = string.format("curl -s -o '%s' '%s'", filename, url)
  local success = os.execute(download_cmd)
  
  if success == 0 then
    return filename
  else
    return nil
  end
end

-- Track display formatting and truncation
function spotify.format_track_display(track_info, max_length)
  if not track_info or track_info.state ~= "playing" then
    return "Nothing Playing"
  end
  
  max_length = max_length or 40
  local display_text
  
  if track_info.artist and track_info.artist ~= "" then
    display_text = track_info.track .. " - " .. track_info.artist
  else
    display_text = track_info.track .. " - " .. track_info.album
  end
  
  -- Truncate if too long
  if #display_text > max_length then
    display_text = display_text:sub(1, max_length - 3) .. "..."
  end
  
  return display_text
end

-- Check if sbar is available (for testing purposes)
if not sbar then
  return spotify
end

-- Create the main Spotify item
local spotify_item = sbar.add("item", "spotify.name", {
  position = "center",
  update_freq = 2, -- Update every 2 seconds
  icon = {
    string = icons.spotify,
    color = colors.catppuccin.mocha.green,
    padding_left = settings.spacing.icon_padding_left,
    padding_right = 6,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = {
    string = "Nothing Playing",
    color = colors.catppuccin.mocha.text,
    padding_right = settings.spacing.label_padding_right,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
  },
  background = {
    drawing = false, -- Remove background to match bash config
  },
  popup = {
    horizontal = "on", -- Horizontal layout for cover next to controls
    align = "center",
    background = {
      corner_radius = settings.popup.corner_radius,
      color = colors.catppuccin.mocha.base,
      border_width = settings.popup.border_width,
      border_color = colors.catppuccin.mocha.surface1,
    },
    height = 120,
  },
})

-- Create album cover item (positioned first in popup)
local spotify_cover = sbar.add("item", "spotify.cover", {
  position = "popup.spotify.name",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    drawing = true,
    corner_radius = 8,
    height = 50, -- Smaller height for the image container
    image = {
      scale = 0.15, -- Larger scale since container is smaller
      drawing = true,
      corner_radius = 6,
    },
  },
  width = 100,
  padding_left = 12,
  padding_right = 8,
})

-- Create popup control items
local spotify_back = sbar.add("item", "spotify.back", {
  position = "popup.spotify.name",
  icon = {
    string = icons.media.back,
    color = colors.catppuccin.mocha.text,
    padding_left = 5,
    padding_right = 5,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = { drawing = false },
  background = { drawing = false },
})

local spotify_play = sbar.add("item", "spotify.play", {
  position = "popup.spotify.name",
  icon = {
    string = icons.media.play,
    color = colors.catppuccin.mocha.peach,
    padding_left = 4,
    padding_right = 4,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = { drawing = false },
  background = {
    drawing = true,
    color = colors.catppuccin.mocha.base,
    border_width = 1,
    corner_radius = 20,
    height = 40,
  },
  width = 40,
  align = "center",
})

local spotify_next = sbar.add("item", "spotify.next", {
  position = "popup.spotify.name",
  icon = {
    string = icons.media.next,
    color = colors.catppuccin.mocha.text,
    padding_left = 5,
    padding_right = 5,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = { drawing = false },
  background = { drawing = false },
})

local spotify_shuffle = sbar.add("item", "spotify.shuffle", {
  position = "popup.spotify.name",
  icon = {
    string = icons.media.shuffle,
    color = colors.catppuccin.mocha.overlay0,
    highlight_color = colors.catppuccin.mocha.base,
    padding_left = 5,
    padding_right = 5,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = { drawing = false },
  background = { drawing = false },
})

local spotify_repeat = sbar.add("item", "spotify.repeat", {
  position = "popup.spotify.name",
  icon = {
    string = icons.media["repeat"],
    color = colors.catppuccin.mocha.overlay0,
    highlight_color = colors.catppuccin.mocha.base,
    padding_left = 5,
    padding_right = 10,
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
  },
  label = { drawing = false },
  background = { drawing = false },
})

-- Update function for track information
local function update_spotify()
  local track_info = spotify.get_track_info()
  
  if track_info and (track_info.state == "playing" or track_info.state == "paused") then
    -- Show track info for both playing and paused states
    local display_text
    if track_info.state == "playing" then
      display_text = spotify.format_track_display(track_info, 40)
    else
      -- For paused state, still show track info but indicate it's paused
      if track_info.track and track_info.track ~= "" then
        display_text = track_info.track .. " - " .. track_info.artist .. " (Paused)"
      else
        display_text = "Paused"
      end
    end
    
    spotify_item:set({
      label = { string = display_text },
      drawing = true,
    })
    
    -- Update play/pause icon based on state
    if track_info.state == "playing" then
      spotify_play:set({
        icon = { string = icons.media.pause }
      })
    else
      spotify_play:set({
        icon = { string = icons.media.play }
      })
    end
    
    -- Update shuffle and repeat states
    local shuffle_state = spotify.get_shuffle_state()
    local repeat_state = spotify.get_repeat_state()
    
    spotify_shuffle:set({
      icon = { highlight = shuffle_state }
    })
    
    spotify_repeat:set({
      icon = { highlight = repeat_state }
    })
    
    -- Update album artwork (available for both playing and paused)
    local artwork_url = spotify.get_artwork_url()
    if artwork_url then
      -- Create a unique ID for this track to cache artwork
      local track_id = (track_info.track .. track_info.artist):gsub("[^%w]", "_")
      local artwork_path = spotify.download_artwork(artwork_url, track_id)
      
      if artwork_path then
        spotify_cover:set({
          background = {
            image = artwork_path,
          },
        })
      else
        -- Fallback to no image if download fails
        spotify_cover:set({
          background = {
            image = "",
          },
        })
      end
    else
      -- No artwork available
      spotify_cover:set({
        background = {
          image = "",
        },
      })
    end
  else
    -- Only hide when Spotify is not running or no track loaded
    spotify_item:set({
      label = { string = "Nothing Playing" },
      drawing = true, -- Keep the item visible but don't force close popup
    })
    
    spotify_play:set({
      icon = { string = icons.media.play }
    })
    
    -- Hide album cover when no track
    spotify_cover:set({
      background = {
        image = "",
      },
    })
  end
end

-- Click handlers for media controls
spotify_item:subscribe("mouse.clicked", function()
  spotify_item:set({ popup = { drawing = "toggle" } })
end)

spotify_back:subscribe("mouse.clicked", function()
  spotify.previous_track()
  -- Small delay then update
  sbar.exec("sleep 0.1 && echo 'update'", function()
    update_spotify()
  end)
end)

spotify_play:subscribe("mouse.clicked", function()
  spotify.play_pause()
  -- Small delay then update
  sbar.exec("sleep 0.1 && echo 'update'", function()
    update_spotify()
  end)
end)

spotify_next:subscribe("mouse.clicked", function()
  spotify.next_track()
  -- Small delay then update
  sbar.exec("sleep 0.1 && echo 'update'", function()
    update_spotify()
  end)
end)

spotify_shuffle:subscribe("mouse.clicked", function()
  local new_state = spotify.toggle_shuffle()
  spotify_shuffle:set({
    icon = { highlight = new_state }
  })
end)

spotify_repeat:subscribe("mouse.clicked", function()
  local new_state = spotify.toggle_repeat()
  spotify_repeat:set({
    icon = { highlight = new_state }
  })
end)

-- Subscribe to Spotify events and routine updates
sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")
spotify_item:subscribe("routine", update_spotify)
spotify_play:subscribe("spotify_change", update_spotify)

-- Initial update
update_spotify()

return {
  item = spotify_item,
  update = update_spotify,
  cover = spotify_cover,
  controls = {
    back = spotify_back,
    play = spotify_play,
    next = spotify_next,
    shuffle = spotify_shuffle,
    ["repeat"] = spotify_repeat,
  }
}