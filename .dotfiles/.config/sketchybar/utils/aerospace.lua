-- Aerospace integration utility for sketchybar
-- Provides functions to interact with aerospace window manager

local helpers = require("utils.helpers")

local aerospace = {}

-- Execute aerospace command and return output
local function execute_aerospace_command(cmd)
  local full_cmd = "aerospace " .. cmd
  return helpers.execute_command(full_cmd)
end

-- Get list of all monitors
function aerospace.get_monitors()
  local output = execute_aerospace_command("list-monitors")
  if not output then
    return {}
  end
  
  local monitors = {}
  for line in output:gmatch("[^\r\n]+") do
    local monitor_id = line:match("^(%d+)")
    if monitor_id then
      table.insert(monitors, monitor_id)
    end
  end
  
  return monitors
end

-- Get list of workspaces for a specific monitor
function aerospace.get_workspaces(monitor_id)
  local cmd = monitor_id and ("list-workspaces --monitor " .. monitor_id) or "list-workspaces"
  local output = execute_aerospace_command(cmd)
  if not output then
    return {}
  end
  
  local workspaces = {}
  for workspace in output:gmatch("%S+") do
    table.insert(workspaces, workspace)
  end
  
  return workspaces
end

-- Get all workspaces across all monitors
function aerospace.get_all_workspaces()
  local all_workspaces = {}
  local monitors = aerospace.get_monitors()
  
  for _, monitor in ipairs(monitors) do
    local workspaces = aerospace.get_workspaces(monitor)
    for _, workspace in ipairs(workspaces) do
      table.insert(all_workspaces, {
        id = workspace,
        monitor = monitor
      })
    end
  end
  
  return all_workspaces
end

-- Get currently focused workspace
function aerospace.get_focused_workspace()
  local output = execute_aerospace_command("list-workspaces --focused")
  if not output then
    return nil
  end
  
  return output:match("%S+")
end

-- Switch to a specific workspace
function aerospace.switch_to_workspace(workspace_id)
  if not workspace_id then
    helpers.log_error("aerospace.switch_to_workspace: workspace_id is required")
    return false
  end
  
  local output = execute_aerospace_command("workspace " .. workspace_id)
  return output ~= nil
end

-- Get windows in a specific workspace
function aerospace.get_workspace_windows(workspace_id)
  if not workspace_id then
    return {}
  end
  
  local output = execute_aerospace_command("list-windows --workspace " .. workspace_id)
  if not output then
    return {}
  end
  
  local windows = {}
  for line in output:gmatch("[^\r\n]+") do
    -- Parse window information (format may vary)
    if line:match("%S+") then
      table.insert(windows, line)
    end
  end
  
  return windows
end

-- Check if aerospace is available
function aerospace.is_available()
  local output = helpers.execute_command("which aerospace")
  return output ~= nil and output:match("/aerospace") ~= nil
end

-- Get aerospace version
function aerospace.get_version()
  local output = execute_aerospace_command("--version")
  if output then
    return output:match("v?([%d%.]+)")
  end
  return nil
end

-- Create aerospace event subscription helper
function aerospace.create_workspace_change_event()
  return "aerospace_workspace_change"
end

-- Get workspace display information
function aerospace.get_workspace_info(workspace_id)
  if not workspace_id then
    return nil
  end
  
  local focused = aerospace.get_focused_workspace()
  local windows = aerospace.get_workspace_windows(workspace_id)
  
  return {
    id = workspace_id,
    is_focused = focused == workspace_id,
    window_count = #windows,
    windows = windows
  }
end

return aerospace