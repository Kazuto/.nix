{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "desktop"
    "addons"
    "hyprpaper"
  ];

  output = {
    environment.systemPackages = with pkgs; [ hyprpaper ];

    config.${namespace}.home.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    config.${namespace}.home.configFile."hypr/wallpaper".source = ./wallpaper;
  };
}



