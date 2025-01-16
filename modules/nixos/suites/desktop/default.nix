{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable desktop configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        bitwarden = enabled;
        firefox = enabled;
        brave = enabled;
        mailspring = enabled;
        nextcloud = enabled;
      };
    };
  };
}
