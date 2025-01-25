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

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
          configFile."hypr/wallpaper".source = ./wallpaper;        };
      };
    };

    environment.systemPackages = with pkgs; [ hyprpaper ];
  };
}



