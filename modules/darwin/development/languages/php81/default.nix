{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.php81;
in
{
  options.shiro.development.languages.php81 = with types; {
    enable = mkBoolOpt false "Whether or not to use PHP 8.1.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      (php81.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
           gd imagick opcache pcov redis xdebug
        ]));

        extraConfig = ''
          memory_limit=4G
          xdebug.idekey=nvim
          xdebug.mode=debug
        '';
      })

      imagemagick
      php81Extensions.imagick

      php81Packages.composer
    ];
  };
}
