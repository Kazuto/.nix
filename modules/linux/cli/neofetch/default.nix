{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.neofetch;
in
{
  options.${namespace}.cli.neofetch = with types; {
    enable = mkBoolOpt false "Whether or not to install neofetch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neofetch ];
  };
}
