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
      (php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug imagick gd phan
        ]));
        extraConfig = ''
          memory_limit = 8G
          IDE Key = nvim
          xdebug.mode = debug
        '';
      })

      php81Packages.composer
      php81Extensions.imagick
    ];
  };
}
