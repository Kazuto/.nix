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
    home.packages = with pkgs; [ vscode ];
  };
}


