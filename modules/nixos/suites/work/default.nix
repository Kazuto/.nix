{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.work;
in
{
  options.shiro.suites.work = with types; {
    enable = mkBoolOpt false "Whether or not to enable work configuration.";
  };

  config = mkIf cfg.enable {
    shiro.apps.teams = enabled;
  };
}
