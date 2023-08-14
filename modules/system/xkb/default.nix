{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.system.xkb;
in
{
  options.shiro.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to configure keyboard settings.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver = {
      layout = "de";
      xkbVariant = "mac_nodeadkeys";
    };
  };
}

