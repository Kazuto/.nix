{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.docker;
in
{
  options.shiro.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    users.users.${config.shiro.user.name}.extraGroups = ["docker"];

    # Allow rootless Docker to bind to privileged ports (< 1024)
    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 80;
    };
  };
}
