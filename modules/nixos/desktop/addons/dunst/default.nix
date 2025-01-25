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

  output = {
    environment.systemPackages = with pkgs; [ dunst libnotify ];

    services.dbus.enable = true;

    config.${namespace}.home.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}



