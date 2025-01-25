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
    "pre-commit"
  ];

  output = {
    home.packages = with pkgs; [ pre-commit ];
  };
}