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
    "nautilus"
  ];

  output = {
    environment.systemPackages = with pkgs; [
      nautilus
      sushi
    ];
  };
}
