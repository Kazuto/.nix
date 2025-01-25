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
    "bitwarden"
  ];

  output = {
    home.packages = with pkgs; [ bitwarden ];
  };
}