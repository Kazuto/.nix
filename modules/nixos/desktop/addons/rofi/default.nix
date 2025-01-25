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

  output = {
    environment.systemPackages = with pkgs; [ rofi-wayland ];

    config.${namespace}.home.configFile."rofi/themes".source = ./themes;
  };
}



