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
    "cli"
    "ripgrep"
  ];

  output = {
    home.packages = with pkgs; [ ripgrep ];
  };
}