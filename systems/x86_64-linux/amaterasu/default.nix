{
  pkgs,
  lib,
  nixos-hardware,
  ...
}:
with lib;
with lib.shiro; {
  imports = [./hardware.nix];

  shiro = {
    layouts = {
      workstation = enabled;
    };

    desktop = {
      hyprland = enabled;
    };

    suites = {
      gaming = enabled;
    };

    apps = {
      gparted = enabled;
      remmina = enabled;
    };

    tools = {
      docker = enabled;
    };

    security = {
      yubikey = enabled;
    };
  };

  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  nix.settings = {
    substituters = ["https://attic.xuyh0120.win/lantian"];
    trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  };

  networking.hostName = "amaterasu";

  system.stateVersion = "24.11";
}
