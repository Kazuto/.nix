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

  system.stateVersion = "23.05";
}
