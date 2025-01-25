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
    "beekeeper"
  ];

  output = {
    home.packages = with pkgs; [ beekeeper-studio ];
  };
}


