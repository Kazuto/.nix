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
    "tools"
    "kitty"
  ];

  extraOptions = {
    home.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };

  output = {
    home.packages = with pkgs; [ kitty ];
  };
}


