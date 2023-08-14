
{ lib, config, ... }:

let
  cfg = config.shiro.hardware.printing;
in
{
  options.shiro.hardware.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing settings.";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
  };
}


