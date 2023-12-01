{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let cfg = config.shiro.layouts.workstation;
in
{
  options.shiro.layouts.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation layout.";
  };

  config = mkIf cfg.enable {
    shiro = {
      suites = {
        common = enabled;
        development = enabled;
        media = enabled;
        social = enabled;
      };
    };
  };
}
