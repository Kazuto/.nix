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
    "apps"
    "prismlauncher"
  ];

  output = {
    environment.systemPackages = with pkgs; [ prismlauncher ];
  };
}