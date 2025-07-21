{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.sqlite;
  user = config.shiro.user;
in
{
  options.shiro.development.tools.sqlite = with types; {
    enable = mkBoolOpt false "Whether or not to use sqlite.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      sqlite
    ];
  };
}
