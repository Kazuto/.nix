{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.desktop.addons.thunar;
in
{
  options.${namespace}.desktop.addons.thunar = with types; {
    enable = mkBoolOpt false "Whether or not to install Thunar.";
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
       thunar-archive-plugin
       thunar-volman
       thunar-media-tags-plugin
      ];
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
