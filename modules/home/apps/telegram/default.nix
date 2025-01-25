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
    "telegram"
  ];

  output = {
    home.packages = with pkgs; [ telegram-desktop ];
  };
}