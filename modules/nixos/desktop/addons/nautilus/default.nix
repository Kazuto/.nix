{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.desktop.addons.nautilus;
in
{
  options.${namespace}.desktop.addons.nautilus = with types; {
    enable = mkBoolOpt false "Whether or not to install Nautilus.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.gnome; [
      nautilus
      sushi
    ];
  };
}
