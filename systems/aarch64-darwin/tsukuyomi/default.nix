{ pkgs, lib, ... }:

with lib;
with lib.shiro;
{
  shiro = {
    layouts = {
      workstation = enabled;
    };

    suites = {
      smake = enabled;
      tiling = enabled;
      gaming = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
