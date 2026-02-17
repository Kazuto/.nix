local colors = require("colors")
local icons  = require("icons")

local GH = "/run/current-system/sw/bin/gh"

local github = sbar.add("item", "github", {
  position = "right",
  icon = {
    string        = icons.github,
    font          = "sketchybar-app-font:Regular:13.0",
    color         = colors.lavender,
    padding_left  = 8,
    padding_right = 6,
  },
  label = { padding_right = 8 },
  update_freq = 60,
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

github:subscribe("mouse.entered", function()
  github:set({ popup = { drawing = true } })
end)

github:subscribe("mouse.exited", function()
  github:set({ popup = { drawing = false } })
end)

github:subscribe("mouse.exited.global", function()
  github:set({ popup = { drawing = false } })
end)

local function update_github()
  sbar.exec(GH .. " api /notifications --jq 'length'", function(count_str)
    local cleaned = (count_str:gsub("%s+", ""))
    local count = tonumber(cleaned) or 0

    if count > 0 then
      github:set({
        icon  = { color = colors.red },
        label = count .. " Notifications",
      })
    else
      github:set({
        icon  = { color = colors.lavender },
        label = "0 Notifications",
      })
    end

    sbar.exec(
      GH .. [[ api /notifications --jq '.[] | "\(.id)|\(.repository.full_name)|\(.subject.title)|\(.subject.type)|\(.subject.url)"']],
      function(result)
        for line in result:gmatch("[^\r\n]+") do
          local id, repo, title, stype, surl = line:match("^(.-)|(.-)|(.-)|(.-)|(.*)$")
          if id and repo then
            local subject_id = surl:match("[^/]+$") or ""
            local html_path = "issues"
            if stype == "PullRequest" then html_path = "pull" end
            local html_url = "https://github.com/" .. repo .. "/" .. html_path .. "/" .. subject_id

            local notif_item = sbar.add("item", "github." .. id, {
              position      = "popup." .. github.name,
              label         = { string = repo .. ": " .. title },
              padding_left  = 16,
              padding_right = 16,
              background    = { drawing = false },
            })

            notif_item:subscribe("mouse.clicked", function()
              sbar.exec("open '" .. html_url .. "'")
              github:set({ popup = { drawing = false } })
            end)
          end
        end
      end
    )
  end)
end

github:subscribe("routine", update_github)
github:subscribe("forced", update_github)
