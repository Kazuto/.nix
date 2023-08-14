{ pkgs, lib, nixos-hardware, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  shiro = {
    nix = enabled;

    desktop = {
      hyprland = enabled;
    };

    suites = {
      common = enabled;
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
