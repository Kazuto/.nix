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

    suites = {
      core = enabled;
      desktop = enabled;
      development = enabled;
      gaming = enabled;
      media = enabled;
      social = enabled;
    };

    apps = {
      gparted = enabled;
      remmina = enabled;
    };
  };

  networking.hostName = "amaterasu";

  system.stateVersion = "24.11";
}
