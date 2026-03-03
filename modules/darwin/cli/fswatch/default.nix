{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.fswatch;
in
{
  options.shiro.cli.fswatch = with types; {
    enable = mkBoolOpt false "Whether or not to install fswatch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fswatch ];
  };
}
