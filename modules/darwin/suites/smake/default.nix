{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.smake;
in
{
  options.shiro.suites.smake = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      development.tools = {
        canvas = enabled;
        ghostscript = enabled;
        mailhog = enabled;
        meilisearch = enabled;
      };

      cli = {
        gitleaks = enabled;
        pre-commit = enabled;
        skeema = enabled;
      };
    };
  };
}
