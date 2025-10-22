-- System information utility for sketchybar
-- Provides functions to get system metrics and information

local helpers = require("utils.helpers")

local system = {}

-- Cache for frequently accessed data
local cache = {
  core_count = nil,
  last_cpu_update = 0,
  cpu_data = nil
}

-- Cache duration in seconds
local CACHE_DURATION = 1

-- Get CPU core count
function system.get_core_count()
  if cache.core_count then
    return cache.core_count
  end
  
  local output = helpers.execute_command("sysctl -n machdep.cpu.thread_count")
  if output then
    cache.core_count = tonumber(output:match("%d+"))
  end
  
  return cache.core_count or 1
end

-- Get CPU usage information
function system.get_cpu_usage()
  local current_time = os.time()
  
  -- Return cached data if still valid
  if cache.cpu_data and (current_time - cache.last_cpu_update) < CACHE_DURATION then
    return cache.cpu_data
  end
  
  local core_count = system.get_core_count()
  local username = os.getenv("USER") or "unknown"
  
  -- Get CPU information using ps command
  local cpu_info = helpers.execute_command("ps -eo pcpu,user")
  if not cpu_info then
    return { user = 0, system = 0, total = 0 }
  end
  
  local cpu_user = 0
  local cpu_sys = 0
  
  -- Parse CPU information
  for line in cpu_info:gmatch("[^\r\n]+") do
    local pcpu, user = line:match("([%d%.]+)%s+(%S+)")
    if pcpu and user then
      local cpu_val = tonumber(pcpu) or 0
      if user == username then
        cpu_user = cpu_user + cpu_val
      else
        cpu_sys = cpu_sys + cpu_val
      end
    end
  end
  
  -- Normalize by core count
  cpu_user = cpu_user / (100.0 * core_count)
  cpu_sys = cpu_sys / (100.0 * core_count)
  
  local total_percent = math.floor((cpu_user + cpu_sys) * 100)
  
  cache.cpu_data = {
    user = math.floor(cpu_user * 100),
    system = math.floor(cpu_sys * 100),
    total = total_percent
  }
  cache.last_cpu_update = current_time
  
  return cache.cpu_data
end

-- Get memory usage information
function system.get_memory_usage()
  local vm_stat = helpers.execute_command("vm_stat")
  if not vm_stat then
    return { used = 0, total = 0, percentage = 0 }
  end
  
  local page_size = 4096 -- Default page size on macOS
  local pages_free = vm_stat:match("Pages free:%s*(%d+)")
  local pages_active = vm_stat:match("Pages active:%s*(%d+)")
  local pages_inactive = vm_stat:match("Pages inactive:%s*(%d+)")
  local pages_speculative = vm_stat:match("Pages speculative:%s*(%d+)")
  local pages_wired = vm_stat:match("Pages wired down:%s*(%d+)")
  
  if not (pages_free and pages_active and pages_inactive and pages_wired) then
    return { used = 0, total = 0, percentage = 0 }
  end
  
  local free = tonumber(pages_free) * page_size
  local active = tonumber(pages_active) * page_size
  local inactive = tonumber(pages_inactive) * page_size
  local speculative = tonumber(pages_speculative or 0) * page_size
  local wired = tonumber(pages_wired) * page_size
  
  local used = active + inactive + wired
  local total = used + free + speculative
  local percentage = math.floor((used / total) * 100)
  
  return {
    used = used,
    total = total,
    percentage = percentage
  }
end

-- Get battery information
function system.get_battery_info()
  local pmset_output = helpers.execute_command("pmset -g batt")
  if not pmset_output then
    return { percentage = 0, charging = false, time_remaining = nil }
  end
  
  local percentage = pmset_output:match("(%d+)%%")
  local charging = pmset_output:match("AC Power") ~= nil
  local time_remaining = pmset_output:match("(%d+:%d+) remaining")
  
  return {
    percentage = tonumber(percentage) or 0,
    charging = charging,
    time_remaining = time_remaining
  }
end

-- Get volume information
function system.get_volume_info()
  local osascript_cmd = [[osascript -e "output volume of (get volume settings)"]]
  local volume_output = helpers.execute_command(osascript_cmd)
  
  if not volume_output then
    return { level = 0, muted = false }
  end
  
  local volume_level = tonumber(volume_output:match("%d+")) or 0
  
  -- Check if muted
  local mute_cmd = [[osascript -e "output muted of (get volume settings)"]]
  local mute_output = helpers.execute_command(mute_cmd)
  local muted = mute_output and mute_output:match("true") ~= nil
  
  return {
    level = volume_level,
    muted = muted
  }
end

-- Get current date and time
function system.get_datetime()
  local date_output = helpers.execute_command("date '+%a %d %b %I:%M %p'")
  if date_output then
    return date_output:gsub("\n", "")
  end
  return os.date("%a %d %b %I:%M %p")
end

-- Get system uptime
function system.get_uptime()
  local uptime_output = helpers.execute_command("uptime")
  if uptime_output then
    local days = uptime_output:match("(%d+) days?")
    local hours, minutes = uptime_output:match("(%d+):(%d+)")
    
    if days then
      return string.format("%s days, %s:%s", days, hours or "00", minutes or "00")
    elseif hours and minutes then
      return string.format("%s:%s", hours, minutes)
    end
  end
  return "Unknown"
end

-- Get current user
function system.get_current_user()
  return os.getenv("USER") or "unknown"
end

-- Get hostname
function system.get_hostname()
  local hostname = helpers.execute_command("hostname -s")
  if hostname then
    return hostname:gsub("\n", "")
  end
  return "unknown"
end

-- Get macOS version
function system.get_macos_version()
  local version = helpers.execute_command("sw_vers -productVersion")
  if version then
    return version:gsub("\n", "")
  end
  return "unknown"
end

-- Clear cache (useful for testing or manual refresh)
function system.clear_cache()
  cache.core_count = nil
  cache.last_cpu_update = 0
  cache.cpu_data = nil
end

-- Get system load average
function system.get_load_average()
  local uptime_output = helpers.execute_command("uptime")
  if uptime_output then
    local load1, load5, load15 = uptime_output:match("load averages: ([%d%.]+) ([%d%.]+) ([%d%.]+)")
    if load1 then
      return {
        one_min = tonumber(load1),
        five_min = tonumber(load5),
        fifteen_min = tonumber(load15)
      }
    end
  end
  return { one_min = 0, five_min = 0, fifteen_min = 0 }
end

return system