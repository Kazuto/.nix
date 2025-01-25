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
    "development"
    "tools"
    "bruno"
  ];

  output = {
    home.packages = with pkgs; [ bruno ];
  };
}
