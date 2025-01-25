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
    "cli"
    "btop"
  ];

  output = {
    home.packages = with pkgs; [ btop ];
  };
}