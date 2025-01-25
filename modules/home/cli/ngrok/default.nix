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
    home.packages = with pkgs; [ ngrok ];
  };
}