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
    "insomnia"
  ];

  output = {
    home.packages = with pkgs; [ insomnia ];
  };
}


