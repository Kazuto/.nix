{ lib, config, ... }:

let
  cfg = config.shiro.desktop.hyprland;
in
{
  options.shiro.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to install Hyprland and dependencies.";
  };

  config = mkIf cfg.enable {
    shiro.desktop.addons = {
      avizo = enabled;
      dunst = enabled;
      gtk = enabled;
      hyprpaper = enabled;
      hyprpicker = enabled;
      rofi = enabled;
      waybar = enabled;
      wlogout = enabled;
      xdg-portals = enabled;
      electron-support = enabled;
    };

    environment.systemPackages = with pkgs; [
      hyprland
      wayland-protocols
      wlroots
      xwayland
      wl-clipboard

      gst_all_1.gstreamer
      viewnior

      playerctl
      brightnessctl

      xfce.thunar
    ];

    environment.sessionVariables = {
      # If you cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.hyprland = {
      enable = true;

      xwayland = {
        hidpi = true;
        enable = true;
      };
    };

    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = "Hyprland";

        gdm  = {
          enable = true;
          wayland = true;
        };

        # Enable automatic login for the user.
        autoLogin = {
          enable = true;
          user = cfg.users.users.${config.shiro.user.name};
        };
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}


