{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.php81;
in
{
  options.shiro.development.php81 = with types; {
    enable = mkBoolOpt false "Whether or not to use PHP 8.1.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      (php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug imagick
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
