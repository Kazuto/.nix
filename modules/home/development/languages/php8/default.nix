{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.php8;
in
{
  options.shiro.development.languages.php8 = with types; {
    enable = mkBoolOpt false "Whether or not to use PHP 8.2.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; let
      php = php82.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          gd imagick opcache pcov redis xdebug
        ]));

        extraConfig = ''
          memory_limit=4G
          xdebug.idekey=nvim
          xdebug.mode=debug
        '';
      };
    in [
      php
      php.packages.composer

      imagemagick
      blade-formatter
    ];
  };
}
