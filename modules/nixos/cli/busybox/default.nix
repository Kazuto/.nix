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
    environment.systemPackages = with pkgs; [ busybox ];
  };
}