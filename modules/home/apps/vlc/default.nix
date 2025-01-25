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
    "vlc"
  ];

  output = {
    home.packages = with pkgs; [ vlc ];
  };
}