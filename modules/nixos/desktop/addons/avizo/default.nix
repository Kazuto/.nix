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

  output = {
    environment.systemPackages = with pkgs; [ avizo pamixer pulseaudioFull brightnessctl ];

    config.${namespace}.home.configFile."avizo/config.ini".source = ./config.ini;
  };
}



