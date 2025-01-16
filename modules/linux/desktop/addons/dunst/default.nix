{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.dunst;
in
{
  options.${namespace}.desktop.addons.dunst = with types; {
    enable = mkBoolOpt false "Whether or not to install dunst.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dunst libnotify ];

    services.dbus.enable = true;

    shiro.home.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}



