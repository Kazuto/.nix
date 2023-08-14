{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.desktop.addons.rofi;
in
{
  options.shiro.desktop.addons.rofi = with types; {
    enable = mkBoolOpt false "Whether or not to install rofi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rofi-wayland ];

    shiro.home.configFile."rofi/themes".source = ./themes;
  };
}



