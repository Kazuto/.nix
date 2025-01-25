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
    "vscode"
  ];

  output = {
    environment.systemPackages = with pkgs; [ vscode ];
  };
}


