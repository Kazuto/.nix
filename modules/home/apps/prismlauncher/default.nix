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
    home.packages = with pkgs; [ prismlauncher ];
  };
}