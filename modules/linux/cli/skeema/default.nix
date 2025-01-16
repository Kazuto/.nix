{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.skeema;
in
{
  options.${namespace}.cli.skeema = with types; {
    enable = mkBoolOpt false "Whether or not to install skeema";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ skeema ];
  };
}
