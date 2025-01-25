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

  output = {
    environment.systemPackages = with pkgs; [ kitty ];

    config.${namespace}.home.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };
}


