-- Items initialization and loading
-- Loads all item modules in proper order with error handling

local helpers = require("utils.helpers")

-- Item loading configuration
local ITEM_CONFIG = {
  -- Left side items (loaded first)
  left = {
    { name = "apple", module = "items.apple", required = true },
    { name = "spaces", module = "items.spaces", required = true, init_function = "init" },
    { name = "front_app", module = "items.front_app", required = true },
  },
  
  -- Center items
  center = {
    { name = "spotify", module = "items.spotify", required = false },
  },
  
  -- Right side items (from right to left) (loaded last)
  right = {
    { name = "calendar", module = "items.calendar", required = true },
    { name = "audio", module = "items.audio", required = false },
    { name = "logitech", module = "items.logitech", required = false },
    { name = "cpu", module = "items.cpu", required = true },
    { name = "github", module = "items.github", required = false },
    { name = "timer", module = "items.timer", required = false },
    { name = "volume", module = "items.volume", required = true },
    { name = "battery", module = "items.battery", required = true },
  }
}

-- Store loaded modules for access
local loaded_modules = {}

-- Safe module loading with error handling
local function safe_require(module_name, is_required)
  local success, result = pcall(require, module_name)
  
  if success then
    helpers.log_info("Successfully loaded module: " .. module_name)
    return result
  else
    local error_msg = "Failed to load module '" .. module_name .. "': " .. tostring(result)
    
    if is_required then
      helpers.log_error(error_msg)
      -- For required modules, we still continue but log the error
      print("ERROR: " .. error_msg)
    else
      helpers.log_info("Optional module '" .. module_name .. "' not available: " .. tostring(result))
    end
    
    return nil
  end
end

-- Load items in a specific group (left, center, right)
local function load_item_group(group_name, items)
  helpers.log_info("Loading " .. group_name .. " items...")
  
  for _, item_config in ipairs(items) do
    local module_name = item_config.module
    local item_name = item_config.name
    local is_required = item_config.required
    local init_function = item_config.init_function
    
    helpers.log_info("Loading item: " .. item_name .. " (" .. module_name .. ")")
    
    -- Attempt to load the module
    local module = safe_require(module_name, is_required)
    
    if module then
      -- Store the loaded module
      loaded_modules[item_name] = module
      
      -- Call initialization function if specified
      if init_function and type(module[init_function]) == "function" then
        local init_success, init_error = pcall(module[init_function])
        if init_success then
          helpers.log_info("Successfully initialized " .. item_name)
        else
          local error_msg = "Failed to initialize " .. item_name .. ": " .. tostring(init_error)
          helpers.log_error(error_msg)
          print("ERROR: " .. error_msg)
        end
      end
      
      helpers.log_info("Successfully loaded and configured item: " .. item_name)
    else
      if is_required then
        helpers.log_error("Required item '" .. item_name .. "' failed to load")
      else
        helpers.log_info("Optional item '" .. item_name .. "' skipped")
      end
    end
  end
  
  helpers.log_info("Finished loading " .. group_name .. " items")
end

-- Initialize all items in proper order
local function initialize_all_items()
  helpers.log_info("Starting item initialization...")
  
  -- Load items in order: left -> center -> right
  load_item_group("left", ITEM_CONFIG.left)
  load_item_group("center", ITEM_CONFIG.center)
  load_item_group("right", ITEM_CONFIG.right)
  
  helpers.log_info("Item initialization complete")
  
  -- Log summary of loaded items
  local loaded_count = 0
  local failed_count = 0
  
  for group_name, items in pairs(ITEM_CONFIG) do
    for _, item_config in ipairs(items) do
      if loaded_modules[item_config.name] then
        loaded_count = loaded_count + 1
      else
        failed_count = failed_count + 1
      end
    end
  end
  
  helpers.log_info("Item loading summary: " .. loaded_count .. " loaded, " .. failed_count .. " failed/skipped")
end

-- Get a loaded module by name
local function get_loaded_module(item_name)
  return loaded_modules[item_name]
end

-- Check if an item is loaded
local function is_item_loaded(item_name)
  return loaded_modules[item_name] ~= nil
end

-- Reload a specific item
local function reload_item(item_name)
  helpers.log_info("Reloading item: " .. item_name)
  
  -- Find the item configuration
  local item_config = nil
  for group_name, items in pairs(ITEM_CONFIG) do
    for _, config in ipairs(items) do
      if config.name == item_name then
        item_config = config
        break
      end
    end
    if item_config then break end
  end
  
  if not item_config then
    helpers.log_error("Item configuration not found for: " .. item_name)
    return false
  end
  
  -- Clear the module from package.loaded to force reload
  package.loaded[item_config.module] = nil
  
  -- Reload the module
  local module = safe_require(item_config.module, item_config.required)
  
  if module then
    loaded_modules[item_name] = module
    
    -- Call initialization function if specified
    if item_config.init_function and type(module[item_config.init_function]) == "function" then
      local init_success, init_error = pcall(module[item_config.init_function])
      if init_success then
        helpers.log_info("Successfully reloaded and initialized " .. item_name)
        return true
      else
        helpers.log_error("Failed to initialize reloaded " .. item_name .. ": " .. tostring(init_error))
        return false
      end
    end
    
    helpers.log_info("Successfully reloaded item: " .. item_name)
    return true
  else
    helpers.log_error("Failed to reload item: " .. item_name)
    return false
  end
end

-- Initialize all items
initialize_all_items()

-- Export functions for external access
return {
  get_loaded_module = get_loaded_module,
  is_item_loaded = is_item_loaded,
  reload_item = reload_item,
  loaded_modules = loaded_modules
}


