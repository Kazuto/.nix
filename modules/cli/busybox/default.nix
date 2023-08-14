{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.busybox;
in
{
  options.shiro.cli.busybox = with types; {
    enable = mkBoolOpt false "Whether or not to install busybox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ busybox ];
  };
}
