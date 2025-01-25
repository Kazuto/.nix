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
    "dunst"
  ];

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."dunst/dunstrc".source = ./dunstrc;
        };
      };
    };
    
    environment.systemPackages = with pkgs; [ dunst libnotify ];

    services.dbus.enable = true;
  };
}



