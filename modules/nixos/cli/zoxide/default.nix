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
    "zoxide"
  ];

  output = {
    environment.systemPackages = with pkgs; [ zoxide ];
  };
}
