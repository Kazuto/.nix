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
    home.packages = with pkgs; [ ghostty ];
  };
}


