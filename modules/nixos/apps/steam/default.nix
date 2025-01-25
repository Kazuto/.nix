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
    environment.systemPackages = with pkgs; [ steam ];
  };
}