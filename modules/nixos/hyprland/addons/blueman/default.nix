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
    "blueman"
  ];

  output = {
    environment.systemPackages = with pkgs; [ blueman ];
  };
}



