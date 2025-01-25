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

  extraOptions = {
    home.configFile."rofi/themes".source = ./themes;
  };

  output = with config.${namespace}.user; {
    environment.systemPackages = with pkgs; [ rofi-wayland ];
  };
}



