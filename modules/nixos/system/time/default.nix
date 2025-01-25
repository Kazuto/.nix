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
    "time"
  ];

  output = {
    time.timeZone = "Europe/Berlin";
  };
}

