{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.php8;
in
{
  options.shiro.development.languages.php8 = with types; {
    enable = mkBoolOpt false "Whether or not to use PHP 8.x.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (php83.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug imagick
        ]));
        extraConfig = ''
          memory_limit = 8G
          IDE Key = nvim
          xdebug.mode = debug
        '';
      })

      php83Packages.composer
      php83Extensions.imagick
    ];
  };
}
