{ options, config, pkgs, lib, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.interface;
in
{
  options.shiro.system.interface = with types; {
    enable = mkEnableOption "macOS interface";
  };

  config = mkIf cfg.enable {
    system.defaults = {
      dock.autohide = true;

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleShowScrollBars = "Always";
      };
    };
  };
}
