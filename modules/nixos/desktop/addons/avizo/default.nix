{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.avizo;
in
{
  options.${namespace}.desktop.addons.avizo = with types; {
    enable = mkBoolOpt false "Whether or not to install avizo.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ avizo pamixer pulseaudioFull brightnessctl ];

    shiro.home.configFile."avizo/config.ini".source = ./config.ini;
  };
}



