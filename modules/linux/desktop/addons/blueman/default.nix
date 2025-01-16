{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.blueman;
in
{
  options.${namespace}.desktop.addons.blueman = with types; {
    enable = mkBoolOpt false "Whether or not to install blueman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ blueman ];
  };
}



