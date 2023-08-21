{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.services.printing;
in
{
  options.shiro.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing settings.";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;

      drivers = [ pkgs.cups-kyodialog ];
    };
  };
}


