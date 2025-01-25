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
    "curl"
  ];

  output = {
    home.packages = with pkgs; [ curl ];
  };
}