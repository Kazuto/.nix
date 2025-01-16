{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.dbus;
in
{
  options.${namespace}.services.dbus = with types; {
    enable = mkBoolOpt false "Whether or not to configure dbus settings.";
  };

  config = mkIf cfg.enable {
    services.dbus.enable = true;

    services.gvfs.enable = true;
  };
}


