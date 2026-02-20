local colors  = require("colors")
local blueutil = "/run/current-system/sw/bin/blueutil"

local bluetooth = sbar.add("item", "bluetooth", {
  position = "right",
  icon = {
    string        = "󰂯",
    color         = colors.blue,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { padding_right = 8 },
  y_offset = 1,
  popup = {
    align = "right",
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

bluetooth:subscribe("mouse.entered", function()
  bluetooth:set({ popup = { drawing = true } })
end)

bluetooth:subscribe("mouse.exited", function()
  bluetooth:set({ popup = { drawing = false } })
end)

bluetooth:subscribe("mouse.exited.global", function()
  bluetooth:set({ popup = { drawing = false } })
end)

local function update_bluetooth()
  sbar.exec(blueutil .. " --power", function(power)
    power = power:gsub("%s+", "")
    if power == "0" then
      bluetooth:set({
        icon  = { string = "󰂲", color = colors.overlay1 },
        label = { string = "Off", color = colors.overlay1 },
      })
      return
    end

    sbar.exec(
      blueutil .. " --connected --format json | jq -r 'if length == 0 then \"none\" elif length == 1 then .[0].name else .[0].name + \" +\" + ((length - 1) | tostring) end'",
      function(label)
        label = label:gsub("\n", "")
        if label == "none" then
          bluetooth:set({
            icon  = { string = "󰂯", color = colors.blue },
            label = { string = "No devices", color = colors.overlay1 },
          })
        else
          bluetooth:set({
            icon  = { string = "󰂱", color = colors.blue },
            label = { string = label, color = colors.text },
          })
        end
      end
    )
  end)
end

bluetooth:subscribe({ "routine", "forced" }, update_bluetooth)
update_bluetooth()

-- Populate popup with paired devices at startup
sbar.exec(
  blueutil .. ' --paired --format json | jq -r \'.[] | "\\(.address)=\\(.name)=\\(.connected)"\'',
  function(result)
    for line in result:gmatch("[^\r\n]+") do
      local address, name, connected_str = line:match("^(.-)=(.-)=(.+)$")
      if address and name then
        local connected = connected_str == "true"
        local safe_id   = address:gsub("[^%w]", "_")
        local icon      = connected and "󰂱" or "󰂯"
        local color     = connected and colors.blue or colors.overlay1

        local device_item = sbar.add("item", "bluetooth." .. safe_id, {
          position      = "popup." .. bluetooth.name,
          icon          = { string = icon, color = color },
          label         = { string = name, padding_left = 5, color = color },
          padding_left  = 16,
          padding_right = 16,
          background    = { drawing = false },
        })

        local addr_capture = address
        local conn_capture = connected
        device_item:subscribe("mouse.clicked", function()
          local cmd = conn_capture and (blueutil .. " --disconnect ") or (blueutil .. " --connect ")
          bluetooth:set({ popup = { drawing = false } })
          sbar.exec(cmd .. addr_capture, function()
            sbar.exec("sleep 3", function()
              update_bluetooth()
              sbar.trigger("forced")
            end)
          end)
        end)
      end
    end
  end
)
