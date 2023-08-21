{ pkgs, lib, ... }:

with lib;
with lib.shiro;
{
  shiro = {
    layouts = {
      workstation = enabled;
    };

    suites = {
      tiling = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
