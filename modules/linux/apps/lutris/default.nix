{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.apps.lutris;
in
{
  options.shiro.apps.lutris = with types; {
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
