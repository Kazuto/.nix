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
    "apps"
    "gparted"
  ];

  output = {
    environment.systemPackages = with pkgs; [ gparted ];
  };
}
