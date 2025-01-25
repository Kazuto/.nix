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

    shiro.home.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}



