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
    environment.systemPackages = with pkgs; [ gitkraken ];
  };
}


