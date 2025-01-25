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

    shiro.home.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    shiro.home.configFile."hypr/wallpaper".source = ./wallpaper;
  };
}



