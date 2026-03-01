{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.docker;
in
{
  options.shiro.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
