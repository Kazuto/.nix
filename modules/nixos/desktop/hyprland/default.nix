{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
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

    environment.systemPackages = with pkgs; [
      hyprland
      hyprland-share-picker
      hyprland-protocols

      wl-clipboard

      viewnior
      mpv
      grim
      xdg-user-dirs

      jq
      xsel
      nss
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
      xwayland.enable = true;
    };

    services.xserver = {
      enable = true;
      libinput.enable = true;
    };

    services.displayManager = {
      defaultSession = "hyprland";

      gdm = {
        enable = true;
        wayland = true;
      };

      autoLogin = {
        enable = true;
        user = config.shiro.user.name;
      };
    };

    services.gnome-keyring.enable = true;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}


