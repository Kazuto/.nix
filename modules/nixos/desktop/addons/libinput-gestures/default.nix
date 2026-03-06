{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.libinput-gestures;
in
{
  options.shiro.desktop.addons.libinput-gestures = with types; {
    enable = mkBoolOpt false "Whether or not to enable libinput-gestures.";
  };

  config = mkIf cfg.enable {
    # Install libinput-gestures
    environment.systemPackages = with pkgs; [
      libinput-gestures
      wmctrl  # For window management gestures
      xdotool  # For keyboard/mouse simulation
    ];

    # Add user to input group (required for libinput-gestures)
    shiro.user.extraGroups = [ "input" ];

    # Enable libinput with trackpad settings
    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;  # Traditional scrolling (down = down)
        tapping = true;  # Tap to click
        tappingDragLock = true;  # Drag with tap
        disableWhileTyping = true;  # Prevent accidental touches
        middleEmulation = true;  # 3-finger tap = middle click
        scrollMethod = "twofinger";  # 2-finger scrolling
        accelProfile = "adaptive";  # Smooth acceleration
      };
    };

    # macOS-like gestures config
    shiro.home.configFile."libinput-gestures.conf".text = ''
      # macOS-like trackpad gestures

      # 3-finger swipe up - Mission Control (show all workspaces)
      gesture swipe up 3 rofi -show window

      # 3-finger swipe down - App Exposé (show windows of current workspace)
      gesture swipe down 3 hyprctl dispatch togglespecialworkspace

      # 4-finger swipe left/right - Switch between desktops/workspaces
      gesture swipe left 4 hyprctl dispatch workspace e+1
      gesture swipe right 4 hyprctl dispatch workspace e-1

      # Pinch out (zoom out) - Show app launcher (like Launchpad)
      gesture pinch out 4 rofi -show drun

      # Pinch in (zoom in) - Show desktop (minimize all windows)
      gesture pinch in 4 hyprctl dispatch exec "hyprctl clients -j | jq -r '.[] | select(.workspace.id > 0) | .address' | xargs -I {} hyprctl dispatch movetoworkspacesilent special,address:{}"

      # Alternative gestures
      # gesture swipe down 4 hyprctl dispatch killactive  # Close window
      # gesture swipe up 4 hyprctl dispatch fullscreen 1   # Toggle fullscreen
    '';

    # Enable and start libinput-gestures service for the user
    shiro.home.extraOptions = {
      systemd.user.services.libinput-gestures = {
        Unit = {
          Description = "Libinput Gestures";
          Documentation = "https://github.com/bulletmark/libinput-gestures";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
