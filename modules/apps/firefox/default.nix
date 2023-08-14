{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.apps.firefox;
in
{
  options.shiro.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to install firefox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox ];
  };
}
