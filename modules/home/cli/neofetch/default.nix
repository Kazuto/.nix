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
    environment.systemPackages = with pkgs; [ neofetch ];
  };
}