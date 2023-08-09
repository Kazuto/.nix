{ config, pkgs, ... }:

{
  home = {
    username = "kazuto";
    homeDirectory = "/home/kazuto";

    stateVersion = "23.05";

    packages = [];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
