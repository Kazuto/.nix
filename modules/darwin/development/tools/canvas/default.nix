{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.canvas;
  user = config.shiro.user;
in
{
  options.shiro.development.tools.canvas = with types; {
    enable = mkBoolOpt false "Whether or not to use canvas.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      pkg-config
      cairo
      pango
      libpng
      libjpeg
      giflib
      librsvg
      pixman
    ];
  };
}
