{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.suites.gaming;
in
{
  options.${namespace}.suites.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable gaming configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        discord = enabled;
        lutris = enabled;
        prismlauncher = enabled;
        steam = enabled;
      };
    };
  };
}
