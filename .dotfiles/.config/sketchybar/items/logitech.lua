local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Logitech device battery monitoring
-- Device IDs: ED9B3216 (keyboard), B2CF7061 (mouse)

local devices = {
  {
    id = "ED9B3216",
    name = "logitech.keyboard",
    icon = "􀇳", -- keyboard icon
  },
  {
    id = "B2CF7061", 
    name = "logitech.mouse",
    icon = "􀺣", -- mouse icon
  }
}

-- Function to get battery info from solaar
local function get_battery_info(device_id)
  local json_file = "/tmp/logitech_battery_" .. device_id .. ".json"
  local solaar_path = os.getenv("HOME") .. "/.pyenv/shims/solaar"
  
  -- Check if solaar exists
  local solaar_check = io.popen("which " .. solaar_path .. " 2>/dev/null")
  if not solaar_check or solaar_check:read("*a") == "" then
    if solaar_check then solaar_check:close() end
    return nil
  end
  solaar_check:close()
  
  -- Get solaar output
  local handle = io.popen(solaar_path .. " show " .. device_id .. " 2>/dev/null")
  if not handle then
    return nil
  end
  
  local output = handle:read("*a")
  handle:close()
  
  if not output or output == "" then
    return nil
  end
  
  -- Extract battery information
  local battery_line = output:match("Battery:[^\n]*")
  if not battery_line then
    return nil
  end
  
  local percentage = battery_line:match("Battery:%s*(%d+)%%")
  local charging = battery_line:match("RECHARGING") ~= nil
  
  if not percentage then
    return nil
  end
  
  percentage = tonumber(percentage)
  
  -- Determine icon and color based on percentage
  local battery_icon, color
  if charging then
    battery_icon = "􀢋"
    color = colors.catppuccin.mocha.text
  elseif percentage >= 90 then
    battery_icon = "􀛨"
    color = colors.catppuccin.mocha.text
  elseif percentage >= 60 then
    battery_icon = "􀺸"
    color = colors.catppuccin.mocha.text
  elseif percentage >= 30 then
    battery_icon = "􀺶"
    color = colors.catppuccin.mocha.yellow
  elseif percentage >= 10 then
    battery_icon = "􀛩"
    color = colors.catppuccin.mocha.peach
  else
    battery_icon = "􀛪"
    color = colors.catppuccin.mocha.red
  end
  
  -- Save to JSON file for consistency with original script
  local json_content = string.format([[{
  "percentage": %d,
  "charging": %s,
  "icon": "%s",
  "color": "%s",
  "device": "%s"
}]], percentage, charging and "true" or "false", battery_icon, color, device_id)
  
  local json_file_handle = io.open(json_file, "w")
  if json_file_handle then
    json_file_handle:write(json_content)
    json_file_handle:close()
  end
  
  return {
    percentage = percentage,
    charging = charging,
    icon = battery_icon,
    color = color
  }
end

-- Function to update device display
local function update_device(item, device_icon, battery_info)
  if not battery_info then
    item:set({
      icon = { string = device_icon },
      label = { string = "N/A", color = colors.catppuccin.mocha.text },
    })
    return
  end
  
  if battery_info.charging then
    item:set({
      icon = { string = device_icon },
      label = { string = battery_info.icon, color = battery_info.color },
    })
  else
    item:set({
      icon = { string = device_icon },
      label = { 
        string = battery_info.percentage .. "%",
        color = battery_info.color 
      },
    })
  end
end

-- Create items for each device
local logitech_items = {}

for _, device in ipairs(devices) do
  local item = sbar.add("item", device.name, {
    position = "right",
    update_freq = 120,
    icon = {
      string = device.icon,
      font = {
        family = settings.fonts.icons.family,
        style = settings.fonts.icons.style,
        size = settings.fonts.icons.size,
      },
      color = colors.catppuccin.mocha.sky,
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
      drawing = false, -- Remove background to match bash config
    },
    y_offset = settings.y_offset,
  })
  
  -- Set up update function
  item:subscribe("routine", function()
    local battery_info = get_battery_info(device.id)
    update_device(item, device.icon, battery_info)
  end)
  
  -- Initial update
  local battery_info = get_battery_info(device.id)
  update_device(item, device.icon, battery_info)
  
  logitech_items[device.name] = item
end

return logitech_items