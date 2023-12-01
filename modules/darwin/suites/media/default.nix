{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.media;
in
{
  options.shiro.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        spotify = enabled;
        # vlc = enabled;
      };
    };
  };
}
