{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.dunst;
in
{
  options.shiro.desktop.addons.dunst = with types; {
    enable = mkBoolOpt false "Whether or not to install dunst.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dunst libnotify ];

    services.dbus.enable = true;

    shiro.home.configFile."dunst/dunstrc".source = ./dunstrc;
  };
}



