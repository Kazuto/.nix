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
    "obsidian"
  ];

  output = {
    environment.systemPackages = with pkgs; [ obsidian ];
  };
}