local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Audio item for device switching and volume display
local audio = sbar.add("item", "audio", {
  position = "right",
  icon = {
    string = "󰓃",
    font = {
      family = settings.fonts.icons.family,
      style = settings.fonts.icons.style,
      size = settings.fonts.icons.size,
    },
    color = colors.catppuccin.mocha.green,
    padding_left = settings.spacing.icon_padding_left,
    padding_right = settings.spacing.icon_padding_right,
  },
  label = {
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    color = colors.catppuccin.mocha.text,
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
    corner_radius = 10,
    height = 26,
  },
  y_offset = settings.y_offset,
  popup = {
    background = {
      corner_radius = settings.popup.corner_radius,
      color = colors.catppuccin.mocha.base,
      border_width = settings.popup.border_width,
      border_color = colors.catppuccin.mocha.surface1,
    },
    align = "right",
  },
})

-- Function to get audio devices
local function get_audio_devices()
  local devices = {}
  local handle = io.popen("SwitchAudioSource -a -f json 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
      -- Parse JSON output to get output devices
      local json_success, json_result = pcall(function()
        -- Simple JSON parsing for device list
        for line in result:gmatch("[^\r\n]+") do
          local id = line:match('"id"%s*:%s*"([^"]+)"')
          local name = line:match('"name"%s*:%s*"([^"]+)"')
          local type = line:match('"type"%s*:%s*"([^"]+)"')
          
          if id and name and type == "output" and (name:match("Steinberg") or name:match("Speaker")) then
            devices[id] = name
          end
        end
      end)
    end
  end
  return devices
end

-- Function to get current audio device
local function get_current_audio_device()
  local handle = io.popen("SwitchAudioSource -c 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- trim whitespace
  end
  return ""
end

-- Function to update audio item display
local function update_audio_item(volume)
  local current_device = get_current_audio_device()
  local icon = "󰓃"
  local label = current_device
  
  if current_device:match("Steinberg") then
    icon = "􀑈"
    label = current_device
  elseif current_device:match("Speaker") then
    icon = "󰓃"
    if volume and volume ~= "" then
      label = current_device .. " (" .. volume .. "%)"
    else
      label = current_device
    end
  end
  
  audio:set({
    icon = { string = icon },
    label = { string = label },
  })
end

-- Create popup items for device switching
local function create_device_popup()
  local devices = get_audio_devices()
  
  for id, name in pairs(devices) do
    local device_icon = "󰓃"
    if name:match("Steinberg") then
      device_icon = "􀑈"
    elseif name:match("Speaker") then
      device_icon = "󰓃"
    end
    
    sbar.add("item", "audio." .. id, {
      position = "popup.audio",
      icon = {
        string = device_icon,
        font = {
          family = settings.fonts.icons.family,
          style = settings.fonts.icons.style,
          size = settings.fonts.icons.size,
        },
        color = colors.item.text,
      },
      label = {
        string = name,
        font = {
          family = settings.fonts.text.family,
          style = settings.fonts.text.style,
          size = settings.fonts.text.size,
        },
        color = colors.catppuccin.mocha.text,
        padding_left = 5,
      },
      padding_left = 16,
      padding_right = 16,
      background = { drawing = false },
      click_script = "SwitchAudioSource -i " .. id .. "; sketchybar -m --set audio popup.drawing=off",
    })
  end
end

-- Subscribe to volume change events
audio:subscribe("volume_change", function(env)
  local volume = env.INFO
  update_audio_item(volume)
end)

-- Set up hover handlers for popup
audio:subscribe("mouse.entered", function()
  audio:set({ popup = { drawing = true } })
end)

audio:subscribe("mouse.exited", function()
  audio:set({ popup = { drawing = false } })
end)

audio:subscribe("mouse.exited.global", function()
  audio:set({ popup = { drawing = false } })
end)

-- Initial setup
create_device_popup()
update_audio_item()

return audio