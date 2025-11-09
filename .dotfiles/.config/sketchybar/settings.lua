return {
  -- Font configurations
  fonts = {
    text = {
      family = "SF Pro",
      style = "Medium",
      size = 13.0,
    },
    numbers = {
      family = "SF Pro",
      style = "Semibold",
      size = 13.0,
    },
    icons = {
      family = "JetBrainsMono Nerd Font Propo",
      style = "Semibold",
      size = 13.0,
    },
    app_icons = {
      family = "sketchybar-app-font",
      style = "Regular",
      size = 16.0,
    },
    github_icons = {
      family = "sketchybar-app-font",
      style = "Regular",
      size = 13.0,
    },
  },

  -- Legacy font settings for backward compatibility
  label = {
    font = "SF Pro",
    style = "Medium",
    size = 13.0,
  },
  icon = {
    font = "JetBrainsMono Nerd Font Propo",
    style = "Semibold",
    size = 13.0,
  },

  -- Spacing and padding constants
  paddings = 4, -- Match bash config (was 6)
  spacing = {
    icon_padding_left = 8,
    icon_padding_right = 5,
    label_padding_right = 8,
    space_icon_padding_left = 10,
    space_label_padding_right = 20,
    separator_padding = 2,
  },

  -- Update frequency settings for different item types
  update_freq = {
    cpu = 2,
    calendar = 30,
    battery = 120,
    github = 60,
    volume = 0, -- Event-driven
    spotify = 0, -- Event-driven
    timer = 1,
  },

  -- Y-offset settings
  y_offset = 0,

  -- Popup settings
  popup = {
    corner_radius = 10,
    border_width = 1,
  },
}
