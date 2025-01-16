{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.btop;
in
{
  options.${namespace}.cli.btop = with types; {
    enable = mkBoolOpt false "Whether or not to install btop";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ btop ];
  };
}
