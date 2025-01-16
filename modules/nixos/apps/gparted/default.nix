{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.gparted;
in
{
  options.${namespace}.apps.gparted = with types; {
    enable = mkBoolOpt false "Whether or not to install gparted";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gparted ];
  };
}
