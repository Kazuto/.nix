local colors = require("colors")
local icons  = require("icons")

local config_dir = os.getenv("HOME") .. "/.config/sketchybar"

sbar.add("event", "aerospace_workspace_change")

-- Read monitors and workspaces synchronously during config so items are
-- created before front_app, preserving left-side ordering.
local function read_cmd(cmd)
  local h = io.popen(cmd)
  if not h then return "" end
  local out = h:read("*a")
  h:close()
  return out
end

local monitors = read_cmd("aerospace list-monitors | awk '{print $1}'")
for mid in monitors:gmatch("[^\r\n]+") do
  local workspaces = read_cmd("aerospace list-workspaces --monitor " .. mid)
  for sid in workspaces:gmatch("[^\r\n]+") do
    local space = sbar.add("space", "space." .. sid, {
      space             = sid,
      display           = mid,
      icon              = { string = sid, padding_left = 10 },
      label             = {
        padding_right   = 20,
        y_offset        = -1,
        font            = "sketchybar-app-font:Regular:16.0",
      },
      click_script      = "aerospace workspace " .. sid,
    })

    local function update_focus(focused_ws)
      local selected = focused_ws == sid
      space:set({
        background = {
          drawing = selected,
          color   = selected and colors.peach or nil,
        },
        icon  = { color = selected and colors.base or colors.text },
        label = {
          color          = selected and colors.base or colors.text,
          shadow         = { drawing = selected and false or nil },
        },
      })
    end

    space:subscribe("aerospace_workspace_change", function(env)
      update_focus(env.FOCUSED_WORKSPACE)
    end)

    space:subscribe("front_app_switched", function(_)
      sbar.exec("aerospace list-workspaces --focused", function(out)
        update_focus(out:gsub("%s+", ""))
      end)
    end)

    -- Set initial window icons for this space
    local apps = read_cmd(
      "aerospace list-windows --workspace " .. sid .. " | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'"
    )
    local icon_strip = " "
    if apps:gsub("%s+", "") == "" then
      icon_strip = " —"
    else
      for app in apps:gmatch("[^\r\n]+") do
        local mapped = read_cmd(config_dir .. "/plugins/icon_map_fn.sh '" .. app .. "'")
        icon_strip = icon_strip .. " " .. mapped:gsub("\n", "")
      end
    end
    space:set({ label = icon_strip })
  end
end

local space_separator = sbar.add("item", "space_separator", {
  position = "left",
  icon = {
    string        = icons.separator,
    color         = colors.text,
    padding_left  = 2,
    padding_right = 2,
  },
  label      = { drawing = false },
  background = { drawing = false },
})

space_separator:subscribe("space_windows_change", function()
  sbar.exec("aerospace list-monitors | awk '{print $1}'", function(mon_out)
    for mid in mon_out:gmatch("[^\r\n]+") do
      sbar.exec("aerospace list-workspaces --monitor " .. mid, function(ws_out)
        for sid in ws_out:gmatch("[^\r\n]+") do
          sbar.exec(
            "aerospace list-windows --workspace " .. sid .. " | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'",
            function(app_out)
              local icon_strip = " "
              if app_out:gsub("%s+", "") == "" then
                icon_strip = " —"
              else
                for app in app_out:gmatch("[^\r\n]+") do
                  sbar.exec(config_dir .. "/plugins/icon_map_fn.sh '" .. app .. "'", function(icon)
                    icon_strip = icon_strip .. " " .. icon:gsub("\n", "")
                    sbar.set("space." .. sid, { label = icon_strip })
                  end)
                end
              end
              if app_out:gsub("%s+", "") == "" then
                sbar.set("space." .. sid, { label = icon_strip })
              end
            end
          )
        end
      end)
    end
  end)
end)
