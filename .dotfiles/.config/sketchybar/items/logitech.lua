local colors = require("colors")
local icons  = require("icons")

local devices = {
  { serial = "ED9B3216", name = "keyboard", icon = icons.keyboard },
  { serial = "B2CF7061", name = "mouse",    icon = icons.mouse },
}

for _, device in ipairs(devices) do
  local item = sbar.add("item", "logitech." .. device.name, {
    position = "right",
    icon = {
      string        = icons.battery,
      color         = colors.sky,
      padding_left  = 8,
      padding_right = 5,
    },
    label = { padding_right = 8 },
    y_offset    = 1,
    update_freq = 120,
  })

  item:subscribe({ "routine", "forced" }, function()
    local json_file = "/tmp/logitech_battery_" .. device.serial .. ".json"

    -- First try to display from cached JSON
    sbar.exec("cat " .. json_file .. " 2>/dev/null", function(cached)
      if cached ~= "" then
        sbar.exec("echo '" .. cached .. "' | jq -r '.percentage'", function(pct)
          sbar.exec("echo '" .. cached .. "' | jq -r '.charging'", function(charging)
            sbar.exec("echo '" .. cached .. "' | jq -r '.color'", function(color)
              pct      = pct:gsub("\n", "")
              charging = charging:gsub("\n", "")
              color    = color:gsub("\n", "")

              if charging == "true" then
                item:set({ icon = device.icon, label = icons.battery_charging })
              else
                item:set({
                  icon  = device.icon,
                  label = { string = pct .. "%", color = tonumber(color) or colors.text },
                })
              end
            end)
          end)
        end)
      end
    end)

    -- Then update from solaar
    sbar.exec(
      "/Users/kazuto/.pyenv/shims/solaar show " .. device.serial .. " 2>/dev/null | grep 'Battery:' | head -1",
      function(battery_line)
        battery_line = battery_line:gsub("\n", "")
        if battery_line == "" then return end

        local percentage = battery_line:match("Battery:%s*(%d+)%%")
        if not percentage then return end
        local pct = tonumber(percentage)

        local charging = battery_line:find("RECHARGING") and true or false

        local bat_icon, color
        if pct >= 90 then
          bat_icon = icons.battery_full;     color = colors.text
        elseif pct >= 60 then
          bat_icon = icons.battery_high;     color = colors.text
        elseif pct >= 30 then
          bat_icon = icons.battery_medium;   color = colors.yellow
        elseif pct >= 10 then
          bat_icon = icons.battery_low;      color = colors.peach
        else
          bat_icon = icons.battery_critical; color = colors.red
        end

        if charging then bat_icon = icons.battery_charging end

        -- Save to JSON cache
        local json_str = string.format(
          '{"percentage":%d,"charging":%s,"icon":"%s","color":"0x%08X","device":"%s"}',
          pct, tostring(charging), bat_icon, color, device.serial
        )
        sbar.exec("echo '" .. json_str .. "' > " .. json_file)

        if charging then
          item:set({ icon = device.icon, label = bat_icon })
        else
          item:set({
            icon  = device.icon,
            label = { string = pct .. "%", color = color },
          })
        end
      end
    )
  end)
end
