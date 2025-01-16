{ pkgs, lib, nixos-hardware, namespace, ... }:

with lib;
with lib.shiro;
{
  imports = [ ./hardware.nix ];

  shiro = {
    suites = {
      common = enabled;
    };

  };

  system.stateVersion = "24.11";
}
