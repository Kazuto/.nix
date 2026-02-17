local colors = require("colors")
local icons  = require("icons")

local config_dir = os.getenv("HOME") .. "/.config/sketchybar"

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

github:subscribe("mouse.clicked", function()
  sbar.set("github", { popup = { drawing = "toggle" } })
end)

github:subscribe({ "routine", "forced" }, function()
  sbar.exec(string.format([[
    source "%s/.env"
    TMP_OUTPUT=$(mktemp)
    TMP_PARSE=$(mktemp)
    RESPONSE_FILE="/tmp/sketchybar_github_response"

    curl -s -H "Authorization: token $GITHUB_TOKEN" "$GITHUB_NOTIFICATIONS_URL" -o "$TMP_OUTPUT"
    notification_count=$(jq '[.[] | select(.unread == true)] | length' "$TMP_OUTPUT" 2>/dev/null)

    jq -c '.[]' "$TMP_OUTPUT" 2>/dev/null | while read -r notif; do
      subject_url=$(echo "$notif" | jq -r '.subject.url')
      subject_type=$(echo "$notif" | jq -r '.subject.type')
      repo_full_name=$(echo "$notif" | jq -r '.repository.full_name')

      if [ "$subject_url" = "null" ] || [ -z "$subject_url" ] || [ -z "$repo_full_name" ]; then
        echo "$notif" >> "$TMP_PARSE"
        continue
      fi

      subject_id=${subject_url##*/}

      case "$subject_type" in
        PullRequest) html_path="pull" ;;
        Issue) html_path="issues" ;;
        *) echo "$notif" >> "$TMP_PARSE"; continue ;;
      esac

      html_url="https://github.com/$repo_full_name/$html_path/$subject_id"
      echo "$notif" | jq --arg html_url "$html_url" '.subject.html_url = $html_url' >> "$TMP_PARSE"
    done

    if [ -s "$TMP_PARSE" ]; then
      jq -s . "$TMP_PARSE" > "$RESPONSE_FILE"
    fi

    rm -f "$TMP_OUTPUT" "$TMP_PARSE"
    echo "${notification_count:-0}"
  ]], config_dir), function(result)
    local count = tonumber(result:gsub("%s+", "")) or 0

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

    -- Update popup items from cached response
    sbar.exec([[
      RESPONSE_FILE="/tmp/sketchybar_github_response"
      if [ -f "$RESPONSE_FILE" ] && [ -s "$RESPONSE_FILE" ]; then
        jq -c '.[]' "$RESPONSE_FILE" 2>/dev/null | while read -r notification; do
          id=$(echo "$notification" | jq -r '.id')
          repo=$(echo "$notification" | jq -r '.repository.full_name')
          title=$(echo "$notification" | jq -r '.subject.title')
          url=$(echo "$notification" | jq -r '.subject.html_url')
          echo "${id}|${repo}|${title}|${url}"
        done
      fi
    ]], function(notif_result)
      for line in notif_result:gmatch("[^\r\n]+") do
        local id, repo, title, url = line:match("^(.-)|(.-)|(.-)|(.*)")
        if id and repo then
          local notif_item = sbar.add("item", "github." .. id, {
            position      = "popup." .. github.name,
            label         = { string = repo .. ": " .. title },
            padding_left  = 16,
            padding_right = 16,
            background    = { drawing = false },
          })

          notif_item:subscribe("mouse.clicked", function()
            sbar.exec("open '" .. url .. "'")
            github:set({ popup = { drawing = false } })
          end)
        end
      end
    end)
  end)
end)
