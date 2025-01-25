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

  extraOptions = {
    home.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    home.configFile."hypr/wallpaper".source = ./wallpaper;      
  };

  output = with config.${namespace}.user; {
    environment.systemPackages = with pkgs; [ hyprpaper ];
  };
}



