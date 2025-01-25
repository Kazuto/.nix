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
    environment.systemPackages = with pkgs; [ php81Packages.phpstan ];
  };
}
