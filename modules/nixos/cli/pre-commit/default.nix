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
    environment.systemPackages = with pkgs; [ pre-commit ];
  };
}