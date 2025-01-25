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
    "steam"
  ];

  output = {
    home.packages = with pkgs; [ steam ];
  };
}