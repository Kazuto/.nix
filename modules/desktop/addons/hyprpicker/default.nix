{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.desktop.addons.hyprpicker;
in
{
  options.shiro.desktop.addons.hyprpicker = with types; {
    enable = mkBoolOpt false "Whether or not to install hyprpicker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpicker ];
  };
}



