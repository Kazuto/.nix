{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.suites.gaming;
in
{
  options.shiro.suites.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable gaming configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        discord = enabled;
        prismlauncher = enabled;
        steam = enabled;
      };
    };
  };
}
