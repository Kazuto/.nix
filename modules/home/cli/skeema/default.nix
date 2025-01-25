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
    "skeema"
  ];

  output = {
    home.packages = with pkgs; [ skeema ];
  };
}