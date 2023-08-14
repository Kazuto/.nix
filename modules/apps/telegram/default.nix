{ lib, config, ... }:

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
