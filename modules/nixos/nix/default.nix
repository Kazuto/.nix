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
    "nix"
  ];

  output = {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  };
}