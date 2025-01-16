{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.commitizen;
in
{
  options.${namespace}.cli.commitizen = with types; {
    enable = mkBoolOpt false "Whether or not to install Commitizen";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ commitizen ];
  };
}
