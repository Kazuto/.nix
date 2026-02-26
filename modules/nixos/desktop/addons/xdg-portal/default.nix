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
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        configPackages = with pkgs; [ hyprland ];
      };
    };
  };
}



