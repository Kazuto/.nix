{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.work;
in
{
  options.shiro.suites.work = with types; {
    enable = mkBoolOpt false "Whether or not to enable work configuration.";
  };

  config = mkIf cfg.enable {

    networking.extraHosts =
    ''
      127.0.0.2 other-localhost
      127.0.0.1 smake.test
      127.0.0.1 api.smake.test
      127.0.0.1 cdn.smake.test
      127.0.0.1 login.smake.test
      127.0.0.1 multi-shop.smake.test
      127.0.0.1 oauth.smake.test
      127.0.0.1 production.test
      127.0.0.1 shop.smake.test
      127.0.0.1 system.smake.test
    '';
  };
}
