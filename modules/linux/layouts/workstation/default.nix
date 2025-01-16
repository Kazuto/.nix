{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let cfg = config.${namespace}.layouts.workstation;
in
{
  options.${namespace}.layouts.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation layout.";
  };

  config = mkIf cfg.enable {
    shiro = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        media = enabled;
        social = enabled;
      };
    };
  };
}
