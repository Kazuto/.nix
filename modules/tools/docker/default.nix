{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.tools.docker;
in
{
  options.shiro.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to install docker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ docker docker-compose ];

    shiro.user.extraGroups = [ "docker" ];
  };
}
