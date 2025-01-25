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
    environment.systemPackages = with pkgs; [ dbeaver ];
  };
}


