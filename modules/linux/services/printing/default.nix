{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.printing;
in
{
  options.${namespace}.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing settings.";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;

      drivers = [ pkgs.cups-kyodialog ];
    };
  };
}


