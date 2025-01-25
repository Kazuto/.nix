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
    "development"
    "tools"
    "gitkraken"
  ];

  output = {
    home.packages = with pkgs; [ gitkraken ];
  };
}


