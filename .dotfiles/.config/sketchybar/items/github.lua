-- GitHub notifications monitoring item for sketchybar
-- Displays GitHub notification count with proper styling and popup functionality

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Function to load .env file
local function load_env()
  local env_file = os.getenv("HOME") .. "/.config/sketchybar/.env"
  local file = io.open(env_file, "r")
  
  if not file then
    print("GitHub: .env file not found at " .. env_file)
    return
  end
  
  for line in file:lines() do
    -- Skip empty lines and comments
    if line ~= "" and not line:match("^%s*#") then
      -- Match KEY="VALUE" or KEY=VALUE format
      local key, value = line:match('^([%w_]+)%s*=%s*"?([^"]*)"?')
      if key and value then
        -- Remove trailing quotes if present
        value = value:gsub('"$', '')
        -- Set environment variable for this process
        os.setenv = os.setenv or function(k, v)
          -- Lua doesn't have os.setenv, so we'll store in a table
          if not _G.ENV then _G.ENV = {} end
          _G.ENV[k] = v
        end
        os.setenv(key, value)
      end
    end
  end
  
  file:close()
end

-- Load environment variables from .env file
load_env()

-- GitHub configuration
local GITHUB_TOKEN = (_G.ENV and _G.ENV.GITHUB_TOKEN) or os.getenv("GITHUB_TOKEN")
local GITHUB_NOTIFICATIONS_URL = (_G.ENV and _G.ENV.GITHUB_NOTIFICATIONS_URL) or os.getenv("GITHUB_NOTIFICATIONS_URL") or "https://api.github.com/notifications"
local RESPONSE_FILE = "/tmp/sketchybar_github_response"

-- Debug: Check if token is loaded
if GITHUB_TOKEN and GITHUB_TOKEN ~= "" then
  print("GitHub: Token loaded (length: " .. #GITHUB_TOKEN .. ")")
else
  print("GitHub: No token loaded")
end

-- Create GitHub item
local github = sbar.add("item", "github", {
  position = "right",
  icon = {
    string = icons.github,
    color = colors.catppuccin.mocha.lavender,
    font = {
      family = settings.fonts.github_icons.family,
      style = settings.fonts.github_icons.style,
      size = settings.fonts.github_icons.size,
    },
    padding_left = settings.spacing.icon_padding_left,
    padding_right = 6,
  },
  label = {
    string = "0 Notifications",
    color = colors.catppuccin.mocha.text,
    font = {
      family = settings.fonts.text.family,
      style = settings.fonts.text.style,
      size = settings.fonts.text.size,
    },
    padding_right = settings.spacing.label_padding_right,
  },
  background = {
    color = colors.item.bg,
    corner_radius = 10,
    height = 26,
  },
  y_offset = settings.y_offset,
  update_freq = settings.update_freq.github,
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

-- Function to safely execute shell commands with error handling
local function safe_execute(command, fallback)
  local handle = io.popen(command)
  if not handle then
    print("GitHub: Failed to execute command: " .. command)
    return fallback
  end
  
  local result = handle:read("*a")
  local success = handle:close()
  
  if not success then
    print("GitHub: Command failed: " .. command)
    return fallback
  end
  
  return result:gsub("%s+$", "") -- trim whitespace
end

-- Function to fetch GitHub notifications
local function fetch_github_notifications()
  if not GITHUB_TOKEN or GITHUB_TOKEN == "" then
    print("GitHub: No GitHub token found in environment")
    return nil
  end

  -- Use Bearer token format (newer GitHub API standard)
  local curl_command = string.format(
    'curl -s -H "Authorization: Bearer %s" -H "Accept: application/vnd.github.v3+json" "%s" -o "%s" 2>&1',
    GITHUB_TOKEN,
    GITHUB_NOTIFICATIONS_URL,
    RESPONSE_FILE
  )
  
  print("GitHub: Fetching notifications...")
  local result = safe_execute(curl_command, nil)
  
  -- Check if response file exists and has content
  local file = io.open(RESPONSE_FILE, "r")
  if not file then
    print("GitHub: Failed to read response file")
    return nil
  end
  
  local content = file:read("*a")
  file:close()
  
  if content == "" then
    print("GitHub: Empty response from GitHub API")
    return nil
  end
  
  -- Check if response is an error message
  if content:match('"message"') and content:match('"Bad credentials"') then
    print("GitHub: Bad credentials - check your token")
    return nil
  end
  
  print("GitHub: Successfully fetched notifications")
  return content
end

-- Function to count unread notifications using jq
local function count_unread_notifications()
  local jq_command = string.format(
    'jq "[.[] | select(.unread == true)] | length" "%s" 2>/dev/null',
    RESPONSE_FILE
  )
  
  local count_str = safe_execute(jq_command, "0")
  local count = tonumber(count_str) or 0
  
  return count
end

-- Function to process notifications and add HTML URLs
local function process_notifications()
  if not GITHUB_TOKEN or GITHUB_TOKEN == "" then
    return
  end

  -- Create temporary file for processing
  local tmp_file = "/tmp/sketchybar_github_tmp"
  
  -- Process each notification to add HTML URLs
  local process_command = string.format([=[
    jq -c '.[]' "%s" 2>/dev/null | while read -r notif; do
      subject_url=$(echo "$notif" | jq -r '.subject.url')
      subject_type=$(echo "$notif" | jq -r '.subject.type')
      repo_full_name=$(echo "$notif" | jq -r '.repository.full_name')
      
      # If any essential data missing, keep notification unchanged
      if [[ "$subject_url" == "null" || -z "$subject_url" || -z "$repo_full_name" ]]; then
        echo "$notif" >> "%s"
        continue
      fi
      
      # Extract notification ID from the last segment of the URL
      subject_id=${subject_url##*/}
      
      # Map notification type to GitHub URL path segment
      case "$subject_type" in
        PullRequest) html_path="pull" ;;
        Issue) html_path="issues" ;;
        *)
          echo "$notif" >> "%s"
          continue
          ;;
      esac
      
      # Construct html_url for browser links
      html_url="https://github.com/$repo_full_name/$html_path/$subject_id"
      
      # Append html_url to the subject object
      echo "$notif" | jq --arg html_url "$html_url" '.subject.html_url = $html_url' >> "%s"
    done
  ]=], RESPONSE_FILE, tmp_file, tmp_file, tmp_file)
  
  safe_execute(process_command, nil)
  
  -- Combine updated notifications back into a JSON array
  local combine_command = string.format(
    'if [[ -s "%s" ]]; then jq -s . "%s" > "%s"; fi',
    tmp_file, tmp_file, RESPONSE_FILE
  )
  
  safe_execute(combine_command, nil)
  
  -- Clean up temporary file
  safe_execute(string.format('rm -f "%s"', tmp_file), nil)
end

-- Function to update popup with notifications
local function update_popup()
  if not GITHUB_TOKEN or GITHUB_TOKEN == "" then
    return
  end

  -- Clear existing popup items
  safe_execute('sketchybar --remove "/github\\..*/"', nil)
  
  -- Check if response file exists
  local file = io.open(RESPONSE_FILE, "r")
  if not file then
    return
  end
  file:close()
  
  -- Add popup items for each notification
  local add_popup_command = string.format([=[
    if [[ -f "%s" && -s "%s" ]]; then
      jq -c '.[]' "%s" 2>/dev/null | while read -r notification; do
        id=$(echo "$notification" | jq -r '.id')
        repo_name=$(echo "$notification" | jq -r '.repository.full_name')
        subject_title=$(echo "$notification" | jq -r '.subject.title')
        url=$(echo "$notification" | jq -r '.subject.html_url')
        
        if [[ "$id" != "null" && "$repo_name" != "null" && "$subject_title" != "null" ]]; then
          sketchybar --add item "github.${id}" popup.github \
            --set "github.${id}" label="${repo_name}: ${subject_title}" \
            click_script="open '$url'; sketchybar -m --set github popup.drawing=off" \
            padding_left=16 \
            padding_right=16 \
            background.drawing=off
        fi
      done
    fi
  ]=], RESPONSE_FILE, RESPONSE_FILE, RESPONSE_FILE)
  
  safe_execute(add_popup_command, nil)
end

-- Main update function
local function update_github()
  if not GITHUB_TOKEN or GITHUB_TOKEN == "" then
    github:set({
      icon = { color = colors.catppuccin.mocha.overlay0 },
      label = { string = "No Token" }
    })
    return
  end

  -- Fetch notifications
  local response = fetch_github_notifications()
  if not response then
    github:set({
      icon = { color = colors.catppuccin.mocha.overlay0 },
      label = { string = "API Error" }
    })
    return
  end
  
  -- Process notifications to add HTML URLs
  process_notifications()
  
  -- Count unread notifications
  local notification_count = count_unread_notifications()
  
  -- Update item appearance based on notification count
  if notification_count > 0 then
    github:set({
      icon = { color = colors.catppuccin.mocha.red },
      label = { string = notification_count .. " Notifications" }
    })
  else
    github:set({
      icon = { color = colors.catppuccin.mocha.lavender },
      label = { string = "0 Notifications" }
    })
  end
  
  -- Update popup with current notifications
  update_popup()
end

-- Subscribe to routine event for periodic updates
github:subscribe("routine", function()
  update_github()
end)

-- Subscribe to forced update event
github:subscribe("forced", function()
  update_github()
end)

-- Add click handler to toggle popup
github:subscribe("mouse.clicked", function()
  github:set({ popup = { drawing = "toggle" } })
end)

-- Add right-click handler for manual refresh
github:subscribe("mouse.clicked.right", function()
  update_github()
end)

-- Initial update
update_github()

-- Export for external access
return {
  item = github,
  update = update_github
}