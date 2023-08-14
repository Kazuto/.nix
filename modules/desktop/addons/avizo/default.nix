{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.desktop.addons.avizo;
in
{
  options.shiro.desktop.addons.avizo = with types; {
    enable = mkBoolOpt false "Whether or not to install avizo.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ avizo ];

    shiro.home.configFile."avizo/config.ini".source = ./config.ini;
  };
}



