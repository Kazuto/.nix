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
    "spotify"
  ];

  output = {
    home.packages = with pkgs; [ spotify spicetify-cli ];
  };
}
