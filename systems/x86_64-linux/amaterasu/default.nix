{ pkgs, lib, nixos-hardware, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  shiro = {
    layouts = {
      workstation = enabled;
    };

    desktop = {
      hyprland = enabled;
    };

    apps = {
      gparted = enabled;
      remmina = enabled;
    };
  };

  system.stateVersion = "23.05";
}
