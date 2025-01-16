{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.apps.steam;
in
{
  options.${namespace}.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to install steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ steam ];
  };
}
