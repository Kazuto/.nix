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
    "rofi"
  ];

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."rofi/themes".source = ./themes;
        };
      };
    };
    
    environment.systemPackages = with pkgs; [ rofi-wayland ];
  };
}



