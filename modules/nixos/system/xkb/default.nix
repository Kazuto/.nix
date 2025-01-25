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
    "system"
    "xkb"
  ];

  output = {
    console.useXkbConfig = true;

    services.xserver = {
      layout = "de";
      # xkbVariant = "mac_nodeadkeys";
    };
  };
}

