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
    environment.systemPackages = with pkgs; [ wget ];
  };
}
