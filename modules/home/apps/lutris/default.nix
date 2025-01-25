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
    "apps"
    "lutris"
  ];

  output = {
    home.packages = with pkgs; [
      lutris

      # Needed for some installers like League of Legends
      openssl
      gnome.zenity
    ];
  };
}