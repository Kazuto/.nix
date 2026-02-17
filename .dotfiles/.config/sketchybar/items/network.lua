local colors = require("colors")
local icons  = require("icons")

local INTERFACE = "en0"
local PREV_FILE = "/tmp/sketchybar_network_prev"

local network = sbar.add("item", "network", {
  position = "right",
  icon = {
    string        = icons.network,
    color         = colors.green,
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

local net_interface = sbar.add("item", "network.interface", {
  position      = "popup." .. network.name,
  padding_left  = 16,
  padding_right = 16,
  background    = { drawing = false },
})

local net_ip = sbar.add("item", "network.ip", {
  position      = "popup." .. network.name,
  padding_left  = 16,
  padding_right = 16,
  background    = { drawing = false },
})

network:subscribe({ "routine", "forced" }, function()
  sbar.exec(string.format([[
    INTERFACE="%s"
    PREV_FILE="%s"
    CURRENT=$(netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $4 ~ /\./ {print $7, $10; exit}')
    CURRENT_IN=$(echo "$CURRENT" | awk '{print $1}')
    CURRENT_OUT=$(echo "$CURRENT" | awk '{print $2}')
    if [ -f "$PREV_FILE" ]; then
      PREV_IN=$(awk '{print $1}' "$PREV_FILE")
      PREV_OUT=$(awk '{print $2}' "$PREV_FILE")
      DIFF_IN=$((CURRENT_IN - PREV_IN))
      DIFF_OUT=$((CURRENT_OUT - PREV_OUT))
      DOWN=$(echo "$DIFF_IN" | awk '{v=$1/2; if(v>=1048576) printf "%%.1f MB/s",v/1048576; else if(v>=1024) printf "%%.0f KB/s",v/1024; else printf "%%.0f B/s",v}')
      UP=$(echo "$DIFF_OUT" | awk '{v=$1/2; if(v>=1048576) printf "%%.1f MB/s",v/1048576; else if(v>=1024) printf "%%.0f KB/s",v/1024; else printf "%%.0f B/s",v}')
    else
      DOWN="0 B/s"
      UP="0 B/s"
    fi
    echo "$CURRENT_IN $CURRENT_OUT" > "$PREV_FILE"
    IP=$(ipconfig getifaddr "$INTERFACE" 2>/dev/null || echo "N/A")
    echo "${DOWN}|${UP}|${INTERFACE}|${IP}"
  ]], INTERFACE, PREV_FILE), function(result)
    result = result:gsub("\n", "")
    local down, up, iface, ip = result:match("^(.-)|(.-)|(.-)|(.*)")
    if not down then return end

    network:set({ label = "↓" .. down .. " ↑" .. up })
    net_interface:set({ label = "Interface: " .. iface })
    net_ip:set({ label = "IP: " .. ip })
  end)
end)

network:subscribe("mouse.entered", function()
  network:set({ popup = { drawing = true } })
end)

network:subscribe("mouse.exited", function()
  network:set({ popup = { drawing = false } })
end)

network:subscribe("mouse.exited.global", function()
  network:set({ popup = { drawing = false } })
end)
