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
    "ripgrep"
  ];

  output = {
    environment.systemPackages = with pkgs; [ ripgrep ];
  };
}