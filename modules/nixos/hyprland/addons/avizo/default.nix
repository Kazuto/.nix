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
    "avizo"
  ];

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."avizo/config.ini".source = ./config.ini;
        };
      };
    };

    environment.systemPackages = with pkgs; [ avizo pamixer pulseaudioFull brightnessctl ];
  };
}



