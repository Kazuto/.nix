{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.shiro; let
  cfg = config.shiro.suites.development;
in {
  options.shiro.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      development.tools = {
        valet-linux = enabled;
      };
    };
  };
}
