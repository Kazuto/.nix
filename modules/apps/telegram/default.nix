{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.apps.telegram;
in
{
  options.shiro.apps.telegram = with types; {
    enable = mkBoolOpt false "Whether or not to install Telegram";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ telegram-desktop ];
  };
}
