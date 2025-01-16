{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.hyprpicker;
in
{
  options.${namespace}.desktop.addons.hyprpicker = with types; {
    enable = mkBoolOpt false "Whether or not to install hyprpicker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpicker ];
  };
}



