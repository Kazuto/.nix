{ lib, config, ... }:

let
  cfg = config.shiro.suites.desktop;
in
{
  options.shiro.suites.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable desktop configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        bitwarden = enabled;
        brave = enabled;
        mailspring = enabled;
        nextcloud = enabled;
      };
    }
  }
}
