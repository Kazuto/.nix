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
    environment.systemPackages = with pkgs; [ gum ];
  };
}