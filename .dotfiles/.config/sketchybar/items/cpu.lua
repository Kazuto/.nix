local colors = require("colors")
local icons  = require("icons")

local cpu = sbar.add("item", "cpu", {
  position = "right",
  icon = {
    string        = icons.cpu,
    color         = colors.peach,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { padding_right = 8 },
  y_offset    = 1,
  update_freq = 2,
  popup = {
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

-- Popup detail items
local cpu_total = sbar.add("item", "cpu.total", {
  position      = "popup." .. cpu.name,
  padding_left  = 16,
  padding_right = 16,
  background    = { drawing = false },
})

local cpu_user = sbar.add("item", "cpu.user", {
  position      = "popup." .. cpu.name,
  padding_left  = 16,
  padding_right = 16,
  background    = { drawing = false },
})

local cpu_sys = sbar.add("item", "cpu.sys", {
  position      = "popup." .. cpu.name,
  padding_left  = 16,
  padding_right = 16,
  background    = { drawing = false },
})

local cpu_tops = {}
for i = 1, 5 do
  cpu_tops[i] = sbar.add("item", "cpu.top" .. i, {
    position      = "popup." .. cpu.name,
    padding_left  = 16,
    padding_right = 16,
    background    = { drawing = false },
  })
end

cpu:subscribe({ "routine", "forced" }, function()
  sbar.exec([[
    CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
    CPU_INFO=$(ps -eo pcpu,user)
    CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
    CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
    CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"
    CPU_SYS_PERCENT="$(echo "$CPU_SYS" | awk '{printf "%.1f\n", $1*100}')"
    CPU_USER_PERCENT="$(echo "$CPU_USER" | awk '{printf "%.1f\n", $1*100}')"
    TOP_PROCS=$(ps -eo pcpu,comm -r | head -6 | tail -5 | awk '{n=split($2,a,"/"); printf "%.1f%% %s\n", $1, a[n]}')
    echo "${CPU_PERCENT}|${CPU_USER_PERCENT}|${CPU_SYS_PERCENT}|${CORE_COUNT}"
    echo "$TOP_PROCS"
  ]], function(result)
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    if #lines < 1 then return end

    local pct, user_pct, sys_pct, cores = lines[1]:match("^(.-)|(.-)|(.-)|(.*)")
    if not pct then return end

    cpu:set({ label = pct .. "%" })
    cpu_total:set({ label = "Total: " .. pct .. "% (" .. cores .. " threads)" })
    cpu_user:set({ label = "User: " .. user_pct .. "%" })
    cpu_sys:set({ label = "System: " .. sys_pct .. "%" })

    for i = 1, 5 do
      if lines[i + 1] then
        cpu_tops[i]:set({ label = lines[i + 1] })
      end
    end
  end)
end)

cpu:subscribe("mouse.entered", function()
  cpu:set({ popup = { drawing = true } })
end)

cpu:subscribe("mouse.exited", function()
  cpu:set({ popup = { drawing = false } })
end)

cpu:subscribe("mouse.exited.global", function()
  cpu:set({ popup = { drawing = false } })
end)
