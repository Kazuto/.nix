{ pkgs, lib, nixos-hardware, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  shiro = {
    suites = {
      common = enabled;
    };

  };

  system.stateVersion = "24.11";
}
