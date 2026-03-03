{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.ffmpeg;
in
{
  options.shiro.cli.ffmpeg = with types; {
    enable = mkBoolOpt false "Whether or not to install ffmpeg.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ffmpeg ];
  };
}
