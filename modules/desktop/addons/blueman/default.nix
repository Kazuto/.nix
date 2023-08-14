{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.desktop.addons.blueman;
in
{
  options.shiro.desktop.addons.blueman = with types; {
    enable = mkBoolOpt false "Whether or not to install blueman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ blueman ];
  };
}



