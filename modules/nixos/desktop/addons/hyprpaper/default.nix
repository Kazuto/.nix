{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.hyprpaper;
in
{
  options.${namespace}.desktop.addons.hyprpaper = with types; {
    enable = mkBoolOpt false "Whether or not to install hyprpaper.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpaper ];

    shiro.home.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    shiro.home.configFile."hypr/wallpaper".source = ./wallpaper;
  };
}



