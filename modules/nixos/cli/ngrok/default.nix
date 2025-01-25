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
    "ngrok"
  ];

  output = {
    environment.systemPackages = with pkgs; [ ngrok ];
  };
}