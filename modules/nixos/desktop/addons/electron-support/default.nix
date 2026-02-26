{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.electron-support;
in
{
  options.shiro.desktop.addons.electron-support = with types; {
    enable = mkBoolOpt false "Whether or not to enable electron support.";
  };

  config = mkIf cfg.enable {
    shiro.home.configFile."electron-flags.conf".source = ./electron-flags.conf;

    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}



