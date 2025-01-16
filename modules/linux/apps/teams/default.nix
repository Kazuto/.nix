{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.teams;
in
{
  options.${namespace}.apps.teams = with types; {
    enable = mkBoolOpt false "Whether or not to install Teams";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ teams ];
  };
}
