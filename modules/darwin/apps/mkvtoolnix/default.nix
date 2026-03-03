{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.mkvtoolnix;
in
{
  options.shiro.apps.mkvtoolnix = with types; {
    enable = mkBoolOpt false "Whether or not to install MKVToolNix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mkvtoolnix ];
  };
}
