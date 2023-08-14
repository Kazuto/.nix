{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.suites.social;
in
{
  options.shiro.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        discord = enabled;
        teams = enabled;
        telegram = enabled;
      };
    };
  };
}
