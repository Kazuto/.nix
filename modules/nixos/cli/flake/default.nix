{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.flake;
in
{
  options.${namespace}.cli.flake = with types; {
    enable = mkBoolOpt false "Whether or not to install flake";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ snowfallorg.flake ];
  };
}
