{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.hyprpaper;
in
{
  options.shiro.desktop.addons.hyprpaper = with types; {
    enable = mkBoolOpt false "Whether or not to install hyprpaper.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpaper ];

    shiro.home.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    shiro.home.configFile."hypr/wallpaper".source = ./wallpaper;
  };
}



