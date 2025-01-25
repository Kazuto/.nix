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
    home.packages = with pkgs; [ discord ];
  };
}
