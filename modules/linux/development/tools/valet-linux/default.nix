{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.valet-linux;
in
{
  options.shiro.development.tools.valet-linux = with types; {
    enable = mkBoolOpt false "Whether or not to install valet-linux.";
  };

  config = mkIf cfg.enable {
    shiro.development.languages.php8 = enabled;

    services.nginx.enable = true;

    services.mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    services.redis.servers."" = {
      enable = true;
      package = pkgs.redis7;
    };

    services.dnsmasq = {
      enable = true;
      settings.address = "/.test/127.0.0.1";
    };
  };
}
