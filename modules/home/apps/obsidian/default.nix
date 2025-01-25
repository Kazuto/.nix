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
    home.packages = with pkgs; [ obsidian ];
  };
}