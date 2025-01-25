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
    "wget"
  ];

  output = {
    home.packages = with pkgs; [ wget ];
  };
}
