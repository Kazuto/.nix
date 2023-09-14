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
      core = enabled;
      desktop = enabled;
      development = enabled;
      entertainment = enabled;
      gaming = enabled;
      social = enabled;
    };

    apps = {
      gparted = enabled;
      remmina = enabled;
    };

    services = {
      openssh = enabled;
      printing = enabled;
      dbus = enabled;
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
