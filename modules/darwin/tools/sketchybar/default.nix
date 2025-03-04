{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.sketchybar;
in
{
  options.shiro.tools.sketchybar = with types; {
    enable = mkBoolOpt false "Whether or not to install sketchybar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sketchybar ];

    fonts.packages = with pkgs; [
        sketchybar-app-font
    ];

    services.sketchybar = {
      enable = true;
      package = pkgs.sketchybar;
    };
  };
}
