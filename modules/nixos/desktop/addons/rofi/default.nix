{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.rofi;
in
{
  options.${namespace}.desktop.addons.rofi = with types; {
    enable = mkBoolOpt false "Whether or not to install rofi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rofi-wayland ];

    shiro.home.configFile."rofi/themes".source = ./themes;
  };
}



