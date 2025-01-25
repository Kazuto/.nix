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
    environment.systemPackages = with pkgs; [ stow ];
  };
}