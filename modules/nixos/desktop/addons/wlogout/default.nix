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

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."wlogout".source = ./config;
        };
      };
    };

    environment.systemPackages = with pkgs; [ wlogout ];
  };
}



