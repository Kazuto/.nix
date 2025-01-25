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
    "flake"
  ];

  output = {
    home.packages = with pkgs; [ snowfallorg.flake ];
  };
}