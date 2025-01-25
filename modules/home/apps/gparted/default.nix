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
    home.packages = with pkgs; [ gparted ];
  };
}
