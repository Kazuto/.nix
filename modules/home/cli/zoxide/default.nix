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
    home.packages = with pkgs; [ zoxide ];
  };
}
