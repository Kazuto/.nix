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

  extraOptions = {
    home.configFile."avizo/config.ini".source = ./config.ini;
  };

  output = with config.${namespace}.user; {
    environment.systemPackages = with pkgs; [ avizo pamixer pulseaudioFull brightnessctl ];
  };
}



