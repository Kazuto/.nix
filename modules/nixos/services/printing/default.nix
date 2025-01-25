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
    "printing"
  ];

  output = {
    services.printing = {
      enable = true;

      drivers = [ pkgs.cups-kyodialog ];
    };
  };
}


