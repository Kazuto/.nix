-- Spaces item with aerospace integration
-- Dynamically generates workspace items and handles workspace switching

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local aerospace = require("utils.aerospace")
local helpers = require("utils.helpers")

local spaces = {}

-- Configuration for space items
local SPACE_CONFIG = {
  icon = {
    padding_left = settings.spacing.space_icon_padding_left or 10,
    padding_right = 5, -- Add padding between number and app icons
    font = {
      family = "SF Pro", -- Use SF Pro instead of app font for numbers
      style = "Semibold",
      size = 16.0
    }
  },
  label = {
    padding_left = 5, -- Add padding between number and app icons
    padding_right = settings.spacing.space_label_padding_right or 20,
    y_offset = -1,
    font = {
      family = settings.fonts.app_icons.family,
      style = settings.fonts.app_icons.style,
      size = settings.fonts.app_icons.size
    }
  },
  background = {
    corner_radius = 6,
    height = 26,
    drawing = false
  }
}

-- Store created space items for management
local space_items = {}
local space_separator = nil

-- Create a single space item
local function create_space_item(workspace_id, monitor_id)
  local space_name = "space." .. workspace_id
  
  -- Create the space item
  local space_item = sbar.add("space", space_name, {
    space = workspace_id,
    display = monitor_id,
    icon = {
      string = workspace_id,
      padding_left = SPACE_CONFIG.icon.padding_left,
      padding_right = SPACE_CONFIG.icon.padding_right,
      font = SPACE_CONFIG.icon.font,
      color = colors.catppuccin.mocha.text
    },
    label = {
      padding_left = SPACE_CONFIG.label.padding_left,
      padding_right = SPACE_CONFIG.label.padding_right,
      y_offset = SPACE_CONFIG.label.y_offset,
      font = SPACE_CONFIG.label.font,
      color = colors.catppuccin.mocha.text,
      string = " —"  -- Default empty workspace indicator
    },
    background = SPACE_CONFIG.background,
    position = "left"
  })
  
  -- Add click handler for workspace switching
  space_item:set({
    click_script = "aerospace workspace " .. workspace_id
  })
  
  -- Store reference to the item
  space_items[workspace_id] = {
    item = space_item,
    monitor = monitor_id,
    workspace_id = workspace_id
  }
  
  helpers.log_info("Created space item for workspace " .. workspace_id .. " on monitor " .. monitor_id)
  
  return space_item
end

-- Generate all workspace items dynamically
local function generate_workspace_items()
  -- Check if aerospace is available
  if not aerospace.is_available() then
    helpers.log_error("Aerospace is not available - cannot create workspace items")
    return
  end
  
  -- Clear existing space items
  for workspace_id, space_data in pairs(space_items) do
    if space_data.item then
      space_data.item:remove()
    end
  end
  space_items = {}
  
  -- Only show workspaces from primary monitor (monitor 1)
  local monitor_id = "1"
  local workspaces = aerospace.get_workspaces(monitor_id)
  
  if #workspaces == 0 then
    helpers.log_error("No workspaces found for monitor " .. monitor_id)
    return
  end
  
  helpers.log_info("Monitor " .. monitor_id .. " has " .. #workspaces .. " workspaces")
  
  -- Create workspace items
  for _, workspace_id in ipairs(workspaces) do
    create_space_item(workspace_id, monitor_id)
  end
  
  helpers.log_info("Generated " .. helpers.table_length(space_items) .. " workspace items")
end

-- Update workspace visual state
local function update_workspace_state(workspace_id, is_focused)
  local space_data = space_items[workspace_id]
  if not space_data or not space_data.item then
    return
  end
  
  local item = space_data.item
  local text_color = is_focused and colors.catppuccin.mocha.base or colors.catppuccin.mocha.text
  local background_color = is_focused and colors.catppuccin.mocha.peach or colors.catppuccin.mocha.transparent

  item:set({
    background = {
      drawing = is_focused,
      color = background_color
    },
    icon = {
      color = text_color
    },
    label = {
      color = text_color,
      shadow = { drawing = false }
    }
  })
end

-- Update all workspace states based on current focus
local function update_all_workspace_states()
  local focused_workspace = aerospace.get_focused_workspace()
  if not focused_workspace then
    helpers.log_error("Could not get focused workspace")
    return
  end
  
  -- Update all workspace items
  for workspace_id, space_data in pairs(space_items) do
    local is_focused = workspace_id == focused_workspace
    update_workspace_state(workspace_id, is_focused)
  end
  
  helpers.log_info("Updated workspace states - focused: " .. focused_workspace)
end

-- Update window indicators for all workspaces
local function update_window_indicators()
  if not aerospace.is_available() then
    return
  end
  
  -- Only update workspaces from primary monitor (monitor 1)
  local monitor_id = "1"
  local workspaces = aerospace.get_workspaces(monitor_id)
  
  for _, workspace_id in ipairs(workspaces) do
    local space_data = space_items[workspace_id]
    if space_data and space_data.item then
      -- Get windows for this workspace
      local windows = aerospace.get_workspace_windows(workspace_id)
      local icon_strip = ""
      
      if #windows > 0 then
        -- Create icon strip from window applications
        for _, window_line in ipairs(windows) do
          -- Parse application name from window line (format may vary)
          -- Typical format: "window_id | app_name | window_title"
          local app_name = window_line:match("|%s*([^|]+)%s*|")
          if app_name then
            app_name = helpers.trim(app_name)
            local app_icon = helpers.get_app_icon(app_name)
            icon_strip = icon_strip .. " " .. app_icon
          end
        end
      else
        -- Empty workspace indicator
        icon_strip = " —"
      end
      
      -- Update ONLY the label, preserving the icon (workspace number)
      space_data.item:set({
        label = { string = icon_strip }
      })
    end
  end
end

-- Handle aerospace workspace change events
local function handle_workspace_change(env)
  -- Get focused workspace from event environment variable
  local focused_workspace = env.FOCUSED_WORKSPACE
  
  if not focused_workspace then
    -- Fallback to querying aerospace if env var not available
    focused_workspace = aerospace.get_focused_workspace()
  end
  
  if not focused_workspace then
    return
  end
  
  -- Update all workspace items based on focused workspace
  for workspace_id, space_data in pairs(space_items) do
    if space_data and space_data.item then
      local is_focused = workspace_id == focused_workspace
      update_workspace_state(workspace_id, is_focused)
    end
  end
  
  -- Trigger window indicators update
  sbar.trigger("space_windows_change")
end

-- Handle space windows change events
local function handle_space_windows_change(env)
  helpers.log_info("Space windows change event received")
  update_window_indicators()
end

-- Create space separator item
local function create_space_separator()
  if space_separator then
    space_separator:remove()
  end
  
  space_separator = sbar.add("item", "space_separator", {
    position = "left",
    icon = {
      string = icons.space.separator or "􀆊",
      color = colors.catppuccin.mocha.text,
      padding_left = 2,
      padding_right = 2
    },
    label = { drawing = false },
    background = { drawing = false }
  })
  
  -- Subscribe to space windows change events
  space_separator:subscribe("space_windows_change", handle_space_windows_change)
  
  helpers.log_info("Created space separator")
  
  return space_separator
end

-- Initialize spaces module
function spaces.init()
  helpers.log_info("Initializing spaces module")
  
  -- Generate initial workspace items
  generate_workspace_items()
  
  -- Create space separator
  create_space_separator()
  
  -- Add aerospace workspace change event
  sbar.add("event", "aerospace_workspace_change")
  
  -- Add space windows change event
  sbar.add("event", "space_windows_change")
  
  -- Subscribe all space items to workspace change events
  for workspace_id, space_data in pairs(space_items) do
    if space_data.item then
      space_data.item:subscribe("aerospace_workspace_change", handle_workspace_change)
    end
  end
  
  -- Set initial workspace states and window indicators
  update_all_workspace_states()
  update_window_indicators()
  
  helpers.log_info("Spaces module initialized")
end

-- Get space item by workspace ID
function spaces.get_space_item(workspace_id)
  local space_data = space_items[workspace_id]
  return space_data and space_data.item or nil
end

-- Get all space items
function spaces.get_all_space_items()
  local items = {}
  for workspace_id, space_data in pairs(space_items) do
    items[workspace_id] = space_data.item
  end
  return items
end

-- Refresh workspace items (useful for dynamic workspace changes)
function spaces.refresh()
  helpers.log_info("Refreshing workspace items")
  generate_workspace_items()
  
  -- Recreate space separator
  create_space_separator()
  
  -- Re-subscribe to events and update states
  for workspace_id, space_data in pairs(space_items) do
    if space_data.item then
      space_data.item:subscribe("aerospace_workspace_change", handle_workspace_change)
    end
  end
  
  update_all_workspace_states()
  update_window_indicators()
end

-- Update workspace state for a specific workspace
function spaces.update_workspace_state(workspace_id, is_focused)
  update_workspace_state(workspace_id, is_focused)
end

-- Update all workspace states
function spaces.update_all_states()
  update_all_workspace_states()
end

-- Update window indicators
function spaces.update_window_indicators()
  update_window_indicators()
end

-- Get space separator item
function spaces.get_space_separator()
  return space_separator
end

return spaces