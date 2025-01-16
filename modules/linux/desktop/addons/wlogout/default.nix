{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.wlogout;
in
{
  options.${namespace}.desktop.addons.wlogout = with types; {
    enable = mkBoolOpt false "Whether or not to install wlogout.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wlogout ];

    shiro.home.configFile."wlogout".source = ./config;
  };
}



