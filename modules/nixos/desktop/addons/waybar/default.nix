{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.waybar;
in
{
  options.shiro.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Whether or not to install waybar.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      playerctl
      inotify-tools
      solaar
      libnotify
      waybar
    ];

    shiro.home.configFile."waybar/config.jsonc".source = ./config/config.jsonc;
    shiro.home.configFile."waybar/modules.jsonc".source = ./config/modules.jsonc;
    shiro.home.configFile."waybar/style.css".source = ./config/style.css;

    # Use home-manager's waybar module with systemd service
    shiro.home.extraOptions = {
      programs.waybar = {
        enable = true;
        systemd.enable = true;  # Enable systemd service
      };

      # Make scripts executable
      home.file.".config/waybar/scripts/github" = {
        source = ./config/scripts/github;
        executable = true;
      };
      home.file.".config/waybar/scripts/github-menu" = {
        source = ./config/scripts/github-menu;
        executable = true;
      };
      home.file.".config/waybar/scripts/timer" = {
        source = ./config/scripts/timer;
        executable = true;
      };
      home.file.".config/waybar/scripts/logitech" = {
        source = ./config/scripts/logitech;
        executable = true;
      };
      home.file.".config/waybar/scripts/spotify" = {
        source = ./config/scripts/spotify;
        executable = true;
      };
      home.file.".config/waybar/scripts/menu" = {
        source = ./config/scripts/menu;
        executable = true;
      };
      home.file.".config/waybar/scripts/waybar-wttr.py" = {
        source = ./config/scripts/waybar-wttr.py;
        executable = true;
      };
      home.file.".config/waybar/waybar.sh" = {
        source = ./config/waybar.sh;
        executable = true;
      };
    };
  };
}



