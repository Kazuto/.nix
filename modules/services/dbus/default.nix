{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.services.dbus;
in
{
  options.shiro.services.dbus = with types; {
    enable = mkBoolOpt false "Whether or not to configure dbus settings.";
  };

  config = mkIf cfg.enable {
    services.dbus.enable = true;

    services.gvfs.enable = true;
  };
}


