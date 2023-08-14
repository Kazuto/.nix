{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.apps.spotify;
in
{
  options.shiro.apps.spotify = with types; {
    enable = mkBoolOpt false "Whether or not to install Spotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ spotify ];
  };
}
