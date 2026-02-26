{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.communication;
in
{
  options.shiro.suites.communication = with types; {
    enable = mkBoolOpt false "Whether or not to enable communication configuration.";
  };

  config = mkIf cfg.enable {
    shiro.apps = {
      signal = enabled;
    };
  };
}
