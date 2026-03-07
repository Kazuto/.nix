{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.shiro; let
  cfg = config.shiro.desktop.hyprland;
in {
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
      keyd = enabled;
      libinput-gestures = enabled;
      nautilus = enabled;
      rofi = enabled;
      thunar = enabled;
      waybar = enabled;
      wlogout = enabled;
      xdg-portal = enabled;

      blueman = enabled;
      polkit = enabled;
    };

    shiro.home.configFile."hypr/keybind".source = ./keybind;

    shiro.home.extraOptions = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;

        extraConfig = builtins.readFile ./hyprland.conf;

        plugins = [
          inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      hyprland
      hyprland-protocols

      wl-clipboard

      viewnior
      mpv
      grim
      slurp
      xdg-user-dirs

      jq
      xsel
      nss
      cmake
      ninja
      usbutils
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

    services.xserver.enable = true;
    services.libinput.enable = true;

    hardware.graphics.enable = true;

    shiro.user.extraGroups = ["video" "input" "render" "uinput"];

    # Terminal-based login with tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --greeting 'Welcome to Amaterasu' --asterisks --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Suppress Hyprland start warning and enable dark mode
    environment.sessionVariables = {
      HYPRLAND_NO_START_WARNING = "1";

      # Dark mode for applications and browsers
      GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
      QT_STYLE_OVERRIDE = "kvantum-dark";

      # Default browser for xdg-open fallback
      BROWSER = "firefox";
    };

    services.gnome.gnome-keyring.enable = true;

    # Keyd for remapping Caps Lock to Hyper (Ctrl+Shift+Alt)
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Map Caps Lock to a layer (hyper)
            capslock = "overload(hyper, esc)";
          };
          # Hyper layer sends Ctrl+Shift+Alt with other keys
          "hyper:C-S-A" = {
            # All keys in this layer will have Ctrl+Shift+Alt pressed
          };
        };
      };
    };
  };
}
