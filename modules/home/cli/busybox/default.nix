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
    "busybox"
  ];

  output = {
    home.packages = with pkgs; [ busybox ];
  };
}