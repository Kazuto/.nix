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
    "services"
    "dbus"
  ];

  output = {
    services.dbus.enable = true;

    services.gvfs.enable = true;
  };
}


