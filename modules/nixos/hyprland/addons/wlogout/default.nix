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
    "desktop"
    "addons"
    "wlogout"
  ];

  extraOptions = {
    home.configFile."wlogout".source = ./config;
  };

  output = with config.${namespace}.user; {
    environment.systemPackages = with pkgs; [ wlogout ];
  };
}



