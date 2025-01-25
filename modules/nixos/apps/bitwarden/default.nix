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
    environment.systemPackages = with pkgs; [ bitwarden ];
  };
}