{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.cli.btop;
in
{
  options.shiro.cli.btop = with types; {
    enable = mkBoolOpt false "Whether or not to install btop";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ btop ];
  };
}
