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
    "apps"
    "spotify"
  ];

  output = {
    environment.systemPackages = with pkgs; [ spotify ];
  };
}