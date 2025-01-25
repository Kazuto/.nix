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
    "discord"
  ];

  output = {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
