{ pkgs, lib, ... }:

with lib;
with lib.shiro;
{
  shiro = {
    layouts = {
      workstation = enabled;
    };

    suites = {
      work = enabled;
      tiling = enabled;
      gaming = enabled;
    };

    system = {
      homebrew = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  ids.gids.nixbld = 350;
  system.primaryUser = "kazuto";
  system.stateVersion = 4;
}
