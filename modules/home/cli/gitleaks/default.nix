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
    "cli"
    "gitleaks"
  ];

  output = {
    home.packages = with pkgs; [ gitleaks ];
  };
}
