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
    "hyprpicker"
  ];

  output = {
    environment.systemPackages = with pkgs; [ hyprpicker ];
  };
}



