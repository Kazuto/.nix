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
    "dbeaver"
  ];

  output = {
    home.packages = with pkgs; [ dbeaver ];
  };
}


