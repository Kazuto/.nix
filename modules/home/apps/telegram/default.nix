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
    environment.systemPackages = with pkgs; [ telegram-desktop ];
  };
}