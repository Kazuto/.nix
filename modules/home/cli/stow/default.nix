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
    "stow"
  ];

  output = {
    home.packages = with pkgs; [ stow ];
  };
}