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
    "fd"
  ];

  output = {
    home.packages = with pkgs; [ fd ];
  };
}