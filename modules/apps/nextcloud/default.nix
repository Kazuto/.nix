{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.apps.nextcloud;
in
{
  options.shiro.apps.nextcloud = with types; {
    enable = mkBoolOpt false "Whether or not to install Nextcloud (Client)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nextcloud-client ];
  };
}
