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
    environment.systemPackages = with pkgs; [ vlc ];
  };
}