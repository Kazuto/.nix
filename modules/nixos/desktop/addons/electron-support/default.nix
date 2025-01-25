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
    "electron-support"
  ];

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        home = {
          configFile."electron-flags.conf".source = ./electron-flags.conf;
        };
      };
    };

    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}



