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
    "raycast"
  ];

  output = {
    home.packages = with pkgs; [ raycast ];
  };
}