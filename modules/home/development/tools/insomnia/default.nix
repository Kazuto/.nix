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
    environment.systemPackages = with pkgs; [ insomnia ];
  };
}


