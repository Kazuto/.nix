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

    shiro.home.configFile."rofi/themes".source = ./themes;
  };
}



