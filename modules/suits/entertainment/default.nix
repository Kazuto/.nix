{ lib, config, ... }:

let
  cfg = config.shiro.suites.entertainment;
in
{
  options.shiro.suites.entertainment = with types; {
    enable = mkBoolOpt false "Whether or not to enable entertainment configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        spotify = enabled;
      };
    }
  }
}
