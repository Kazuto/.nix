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
    "gum"
  ];

  output = {
    home.packages = with pkgs; [ gum ];
  };
}