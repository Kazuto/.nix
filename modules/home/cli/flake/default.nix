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
    environment.systemPackages = with pkgs; [ snowfallorg.flake ];
  };
}