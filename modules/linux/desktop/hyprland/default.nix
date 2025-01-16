{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to install Hyprland and dependencies.";
  };

  config = mkIf cfg.enable {
    shiro.desktop.addons = {
      avizo = enabled;
      dunst = enabled;
      electron-support = enabled;
      gtk = enabled;
      # hyprload = enabled;
      hyprpaper = enabled;
      hyprpicker = enabled;
      nautilus = enabled;
      rofi = enabled;
      thunar = enabled;
      waybar = enabled;
      wlogout = enabled;
      xdg-portal = enabled;

      blueman = enabled;
      polkit = enabled;
    };

    shiro.home.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    shiro.home.configFile."hypr/keybind".source = ./keybind;
    shiro.home.configFile."hypr/xdg-portal-hyprland".source = ./xdg-portal-hyprland;

    environment.systemPackages = with pkgs; [
      hyprland
      hyprland-share-picker
      hyprland-protocols

      wlroots
      wl-clipboard

      viewnior
      mplayer
      grim
      xdg-user-dirs

      jq
      xsel
      nss_latest
      cmake
      ninja
    ];

    environment.sessionVariables = {
      # If you cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
      # WLR_RENDERER = "vulkan";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
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
        defaultSession = "hyprland";

        gdm  = {
          enable = true;
          wayland = true;
        };

        # Enable automatic login for the user.
        autoLogin = {
          enable = true;
          user = config.${namespace}.user.name;
        };
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };

    services.gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}


