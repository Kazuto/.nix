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

  networking.hostName = "susanoo";

  shiro = {
    suites = {
      core = enabled;
      common = enabled;
    };
  };

  system.stateVersion = "24.11";
}
