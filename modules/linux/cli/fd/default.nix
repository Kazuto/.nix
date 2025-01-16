{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.fd;
in
{
  options.${namespace}.cli.fd = with types; {
    enable = mkBoolOpt false "Whether or not to install fd";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fd ];
  };
}
