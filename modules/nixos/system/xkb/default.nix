{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.xkb;
in
{
  options.shiro.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to configure keyboard settings.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver.xkb = {
      layout = "de";
      variant = "mac_nodeadkeys";
    };
  };
}

