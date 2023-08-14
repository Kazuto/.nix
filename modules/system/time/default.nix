{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.system.time;
in
{
  options.shiro.system.time = with types; {
    enable = mkBoolOpt false "Whether or not to configure timezone information.";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";
  };
}

