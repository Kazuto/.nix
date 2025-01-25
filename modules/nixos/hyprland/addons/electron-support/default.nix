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

  extraOptions = {
    home.configFile."electron-flags.conf".source = ./electron-flags.conf;
  };

  output = with config.${namespace}.user; {

    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}



