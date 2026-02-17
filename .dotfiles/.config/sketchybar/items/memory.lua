local colors = require("colors")
local icons  = require("icons")

local memory = sbar.add("item", "memory", {
  position = "right",
  icon = {
    string        = icons.memory,
    color         = colors.yellow,
    padding_left  = 8,
    padding_right = 5,
  },
  label = { padding_right = 8 },
  y_offset    = 1,
  update_freq = 5,
  popup = {
    background = {
      corner_radius = 10,
      color         = colors.base,
      border_width  = 1,
      border_color  = colors.surface1,
    },
  },
})

local popup_items = {}
for _, name in ipairs({ "usage", "active", "wired", "compressed" }) do
  popup_items[name] = sbar.add("item", "memory." .. name, {
    position      = "popup." .. memory.name,
    padding_left  = 16,
    padding_right = 16,
    background    = { drawing = false },
  })
end

memory:subscribe({ "routine", "forced" }, function()
  sbar.exec([[
    TOTAL_MEM=$(sysctl -n hw.memsize)
    TOTAL_MEM_MB=$((TOTAL_MEM / 1024 / 1024))
    USED_MEM_PAGES=$(vm_stat | awk '/Pages active/ {gsub(/\./,"",$3); print $3}')
    WIRED_MEM_PAGES=$(vm_stat | awk '/Pages wired/ {gsub(/\./,"",$4); print $4}')
    COMPRESSED_MEM_PAGES=$(vm_stat | awk '/Pages occupied by compressor/ {gsub(/\./,"",$5); print $5}')
    PAGE_SIZE=$(sysctl -n hw.pagesize)
    USED_MEM_BYTES=$(( (USED_MEM_PAGES + WIRED_MEM_PAGES + COMPRESSED_MEM_PAGES) * PAGE_SIZE ))
    MEM_PERCENT=$((USED_MEM_BYTES / 1024 / 1024 * 100 / TOTAL_MEM_MB))
    USED_GB=$(echo "$USED_MEM_BYTES" | awk '{printf "%.2f", $1 / 1024 / 1024 / 1024}')
    TOTAL_GB=$(echo "$TOTAL_MEM" | awk '{printf "%.0f", $1 / 1024 / 1024 / 1024}')
    ACTIVE_MB=$(( USED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))
    WIRED_MB=$(( WIRED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))
    COMPRESSED_MB=$(( COMPRESSED_MEM_PAGES * PAGE_SIZE / 1024 / 1024 ))
    echo "${MEM_PERCENT}|${USED_GB}|${TOTAL_GB}|${ACTIVE_MB}|${WIRED_MB}|${COMPRESSED_MB}"
  ]], function(result)
    result = result:gsub("\n", "")
    local pct, used_gb, total_gb, active_mb, wired_mb, compressed_mb =
      result:match("^(.-)|(.-)|(.-)|(.-)|(.-)|(.*)")
    if not pct then return end

    memory:set({ label = pct .. "%" })
    popup_items.usage:set({ label = used_gb .. " / " .. total_gb .. "GB" })
    popup_items.active:set({ label = "Active: " .. active_mb .. "MB" })
    popup_items.wired:set({ label = "Wired: " .. wired_mb .. "MB" })
    popup_items.compressed:set({ label = "Compressed: " .. compressed_mb .. "MB" })
  end)
end)

memory:subscribe("mouse.entered", function()
  memory:set({ popup = { drawing = true } })
end)

memory:subscribe("mouse.exited", function()
  memory:set({ popup = { drawing = false } })
end)

memory:subscribe("mouse.exited.global", function()
  memory:set({ popup = { drawing = false } })
end)
