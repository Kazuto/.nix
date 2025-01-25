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
        experimental-features = "nix-command flakes";
        substitute = "true";
        trusted-users = [ "kazuto" ];
        auto-optimise-store = true;
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
        persistent = true;
      };
      
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
      package = pkgs.lix;
    };
  };
}