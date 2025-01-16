{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.busybox;
in
{
  options.${namespace}.cli.busybox = with types; {
    enable = mkBoolOpt false "Whether or not to install busybox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ busybox ];
  };
}
