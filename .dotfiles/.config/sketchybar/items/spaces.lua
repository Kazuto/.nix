local colors = require("colors")
local icons  = require("icons")

local config_dir = os.getenv("HOME") .. "/.config/sketchybar"

sbar.add("event", "aerospace_workspace_change")

sbar.exec("aerospace list-monitors | awk '{print $1}'", function(monitors)
  for mid in monitors:gmatch("[^\r\n]+") do
    sbar.exec("aerospace list-workspaces --monitor " .. mid, function(workspaces)
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

        space:subscribe("aerospace_workspace_change", function(env)
          local selected = env.FOCUSED_WORKSPACE == sid
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
        end)

        -- Set initial window icons for this space
        sbar.exec(
          "aerospace list-windows --workspace " .. sid .. " | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'",
          function(apps)
            local icon_strip = " "
            if apps == "" then
              icon_strip = " —"
            else
              for app in apps:gmatch("[^\r\n]+") do
                sbar.exec(config_dir .. "/plugins/icon_map_fn.sh '" .. app .. "'", function(icon)
                  icon_strip = icon_strip .. " " .. icon:gsub("\n", "")
                  space:set({ label = icon_strip })
                end)
              end
            end
            if apps == "" then
              space:set({ label = icon_strip })
            end
          end
        )
      end
    end)
  end
end)

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
  sbar.exec("aerospace list-monitors | awk '{print $1}'", function(monitors)
    for mid in monitors:gmatch("[^\r\n]+") do
      sbar.exec("aerospace list-workspaces --monitor " .. mid, function(workspaces)
        for sid in workspaces:gmatch("[^\r\n]+") do
          sbar.exec(
            "aerospace list-windows --workspace " .. sid .. " | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'",
            function(apps)
              local icon_strip = " "
              if apps == "" then
                icon_strip = " —"
              else
                for app in apps:gmatch("[^\r\n]+") do
                  sbar.exec(config_dir .. "/plugins/icon_map_fn.sh '" .. app .. "'", function(icon)
                    icon_strip = icon_strip .. " " .. icon:gsub("\n", "")
                    sbar.set("space." .. sid, { label = icon_strip })
                  end)
                end
              end
              if apps == "" then
                sbar.set("space." .. sid, { label = icon_strip })
              end
            end
          )
        end
      end)
    end
  end)
end)
