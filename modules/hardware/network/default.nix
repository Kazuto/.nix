{ lib, config, ... }:

let
  cfg = config.shiro.hardware.network;
  user = config.shiro.user;
in
{
  options.shiro.hardware.network = with types; {
    enable = mkBoolOpt false "Whether or not to configure network settings.";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        dhcp = "internal";
      };
    };

    user.extraGroups = [ "networkmanager" ];

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}


