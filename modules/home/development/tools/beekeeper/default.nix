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
    environment.systemPackages = with pkgs; [ beekeeper-studio ];
  };
}


