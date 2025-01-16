{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.nextcloud;
in
{
  options.${namespace}.apps.nextcloud = with types; {
    enable = mkBoolOpt false "Whether or not to install Nextcloud (Client)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nextcloud-client ];
  };
}
