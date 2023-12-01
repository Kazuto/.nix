{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.vlc;
in
{
  options.shiro.apps.vlc = with types; {
    enable = mkBoolOpt false "Whether or not to install vlc";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vlc ];
  };
}
