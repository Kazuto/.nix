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
    "btop"
  ];

  output = {
    environment.systemPackages = with pkgs; [ php81Packages.phpstan ];
  };
}
