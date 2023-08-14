{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.tools.docker;
  user = config.shiro.user;
in
{
  options.shiro.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to install docker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ docker docker-compose ];

    user.extraGroups = = [ "docker" ];
  };
}
