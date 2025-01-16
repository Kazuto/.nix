{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.xdg-portal;
in
{
  options.${namespace}.desktop.addons.xdg-portal = with types; {
    enable = mkBoolOpt false "Whether or not to install xdg-portal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils

      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal
        ];
        wlr.enable = true;
      };
    };
  };
}



