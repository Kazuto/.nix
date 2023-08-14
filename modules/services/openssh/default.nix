
{ lib, config, ... }:

let
  cfg = config.shiro.hardware.ssh;
in
{
  options.shiro.hardware.ssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure ssh settings.";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}


