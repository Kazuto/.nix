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
    "wlogout"
  ];

  output = {
    environment.systemPackages = with pkgs; [ wlogout ];

    config.${namespace}.home.configFile."wlogout".source = ./config;
  };
}



