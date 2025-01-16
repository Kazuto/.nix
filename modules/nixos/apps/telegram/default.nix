{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.telegram;
in
{
  options.${namespace}.apps.telegram = with types; {
    enable = mkBoolOpt false "Whether or not to install Telegram";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ telegram-desktop ];
  };
}
