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
    "phpstan"
  ];

  output = {
    home.packages = with pkgs; [ php81Packages.phpstan ];
  };
}
