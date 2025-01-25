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
    environment.systemPackages = with pkgs; [ gitleaks ];
  };
}
