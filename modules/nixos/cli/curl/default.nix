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
    environment.systemPackages = with pkgs; [ curl ];
  };
}