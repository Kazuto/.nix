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

  extraOptions = {
    home.configFile."dunst/dunstrc".source = ./dunstrc;
  };

  output = with config.${namespace}.user; {
    environment.systemPackages = with pkgs; [ dunst libnotify ];

    services.dbus.enable = true;
  };
}



