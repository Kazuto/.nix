{ lib, config, ... }:

let
  cfg = config.shiro.desktop.addons.wlogout;
in
{
  options.shiro.desktop.addons.wlogout = with types; {
    enable = mkBoolOpt false "Whether or not to install wlogout.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wlogout ];

    shiro.home.configFile."wlogout".source = ./config;
  };
}



