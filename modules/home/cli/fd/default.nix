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
    "fd"
  ];

  output = {
    environment.systemPackages = with pkgs; [ fd ];
  };
}