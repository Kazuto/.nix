{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.apps.lutris;
in
{
  options.${namespace}.apps.lutris = with types; {
    enable = mkBoolOpt false "Whether or not to install lutris";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris

      # Needed for some installers like League of Legends
      openssl
      gnome.zenity
    ];
  };
}
