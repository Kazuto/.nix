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
    ];

    programs.waybar.enable = true;

    shiro.home.configFile."waybar".source = ./config;

    # Make scripts executable
    shiro.home.extraOptions = {
      home.file.".config/waybar/scripts/github".executable = true;
      home.file.".config/waybar/scripts/github-menu".executable = true;
      home.file.".config/waybar/scripts/timer".executable = true;
      home.file.".config/waybar/scripts/logitech".executable = true;
    };
  };
}



