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
    environment.systemPackages = with pkgs; [ teams ];
  };
}