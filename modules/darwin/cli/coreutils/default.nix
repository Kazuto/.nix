{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.coreutils;
in
{
  options.shiro.cli.coreutils = with types; {
    enable = mkBoolOpt false "Whether or not to install GNU coreutils (provides timeout, realpath, etc.)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ coreutils ];
  };
}
