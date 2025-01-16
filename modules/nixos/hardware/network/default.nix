{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.network;
in
{
  options.${namespace}.hardware.network = with types; {
    enable = mkBoolOpt false "Whether or not to configure network settings.";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    shiro.user.extraGroups = [ "networkmanager" ];

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}


