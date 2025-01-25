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
    environment.systemPackages = with pkgs; [ firefox ];
  };
}
