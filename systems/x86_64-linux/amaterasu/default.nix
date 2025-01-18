{ 
    pkgs, 
    lib, 
    namespace,
    nixos-hardware,
    ... 
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  networking.hostName = "amaterasu";

  shiro = {
    layouts = {
      workstation = enabled;
    };

    desktop = {
      hyprland = enabled;
    };

    suites = {
      core = enabled;
      common = enabled;
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
  };

  system.stateVersion = "23.05";
}
