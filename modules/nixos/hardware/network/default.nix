{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "hardware"
    "network"
  ];

  output = {
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


