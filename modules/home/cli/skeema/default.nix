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
    environment.systemPackages = with pkgs; [ skeema ];
  };
}