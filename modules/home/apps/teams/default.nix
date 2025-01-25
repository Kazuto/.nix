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
    "teams"
  ];

  output = {
    home.packages = with pkgs; [ teams ];
  };
}