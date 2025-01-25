{ 
    pkgs, 
    lib, 
    namespace,
    ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
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
