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
    environment.systemPackages = with pkgs; [ bruno ];
  };
}
