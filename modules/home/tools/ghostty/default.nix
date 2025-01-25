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
    "tools"
    "ghostty"
  ];

  output = {
    environment.systemPackages = with pkgs; [ ghostty ];
  };
}


