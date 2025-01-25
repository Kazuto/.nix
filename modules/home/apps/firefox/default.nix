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
    "firefox"
  ];

  output = {
    home.packages = with pkgs; [ firefox ];
  };
}
