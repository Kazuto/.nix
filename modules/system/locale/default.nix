{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.system.locale;
in
{
  options.shiro.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to configure locale settings.";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };
  };
}

