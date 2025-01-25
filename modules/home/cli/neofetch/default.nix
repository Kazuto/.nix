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
    "neofetch"
  ];

  output = {
    home.packages = with pkgs; [ neofetch ];
  };
}