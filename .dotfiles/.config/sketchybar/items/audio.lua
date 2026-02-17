local colors = require("colors")

local audio = sbar.add("item", "audio", {
  position = "right",
  icon = {
    color         = colors.green,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { padding_right = 8 },
  y_offset = 1,
  popup = {
    align      = "right",
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

audio:subscribe("mouse.entered", function()
  audio:set({ popup = { drawing = true } })
end)

audio:subscribe("mouse.exited", function()
  audio:set({ popup = { drawing = false } })
end)

audio:subscribe("mouse.exited.global", function()
  audio:set({ popup = { drawing = false } })
end)

local function update_audio(env)
  local volume = env.INFO or "0"
  sbar.exec("SwitchAudioSource -c", function(device)
    device = device:gsub("\n", "")
    local icon, label

    if device:find("Steinberg") then
      icon  = "􀑈"
      label = device
    elseif device:find("Mac") then
      icon  = "􀣺"
      label = device .. " (" .. volume .. "%)"
    elseif device:find("LG") then
      icon  = "󰓃"
      label = device:gsub("%(.+$", "") .. " (" .. volume .. "%)"
    else
      icon  = "􀣺"
      label = device
    end

    audio:set({ icon = icon, label = label })
  end)
end

audio:subscribe("volume_change", update_audio)
audio:subscribe("forced", update_audio)

-- Query current audio source on startup
update_audio({ INFO = nil })

-- Populate audio device popup
sbar.exec(
  "SwitchAudioSource -a -f json | jq -r 'select(.type == \"output\" and (.name | test(\"Steinberg|Mac|LG\"; \"i\"))) | \"\\(.id)=\\(.name)\"'",
  function(result)
    for line in result:gmatch("[^\r\n]+") do
      local id, name = line:match("^(.-)=(.+)$")
      if id and name then
        local icon = "􀣺"
        if name:find("Steinberg") then
          icon = "􀑈"
        elseif name:find("LG") then
          icon = "󰓃"
          name = name:gsub("%(.+$", "")
        end

        local device_item = sbar.add("item", "audio." .. id, {
          position   = "popup." .. audio.name,
          icon       = icon,
          label      = { string = name, padding_left = 5 },
          padding_left  = 16,
          padding_right = 16,
          background = { drawing = false },
        })

        device_item:subscribe("mouse.clicked", function()
          sbar.exec("SwitchAudioSource -i " .. id)
          audio:set({ popup = { drawing = false } })
        end)
      end
    end
  end
)
