{ pkgs, lib, nixos-hardware, ... }:

with lib;
with lib.internal;
{
  imports = [
    imports = [ ./hardware.nix ];
  ];

  shiro = {
    desktop = {
      hyprland = enabled;
    };

    suits = {
      desktop = enabled;
      development = enabled;
      entertainment = enabled;
      social = enabled;
    };

    apps = {
      gparted = enabled;
    };

    services = {
      openssh = enabled;
      printing = enabled;
    };

    system = {
      boot = enabled;
      env = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  system.stateVersion = "23.05";
}
