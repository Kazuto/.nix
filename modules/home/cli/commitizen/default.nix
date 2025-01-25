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
    "commitizen"
  ];

  output = {
    home.packages = with pkgs; [ commitizen ];
  };
}