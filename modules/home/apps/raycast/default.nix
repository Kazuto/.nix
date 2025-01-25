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
    environment.systemPackages = with pkgs; [ raycast ];
  };
}