{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.xdg-portal;
in
{
  options.shiro.desktop.addons.xdg-portal = with types; {
    enable = mkBoolOpt false "Whether or not to install xdg-portal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xdg-utils ];

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        wlr.enable = true;

        # deprecated
        # gtkUsePortal = true;
      };
    };
  };
}



