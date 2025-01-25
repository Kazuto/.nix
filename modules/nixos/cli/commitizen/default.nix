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
    environment.systemPackages = with pkgs; [ commitizen ];
  };
}