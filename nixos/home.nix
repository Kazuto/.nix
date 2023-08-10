{ config, pkgs, ... }:

{
  home = {
    username = "kazuto";
    homeDirectory = "/home/kazuto";

    stateVersion = "23.05";

    packages = with pkgs; [
      # Applications
      bitwarden
      brave
      discord
      firefox-wayland
      mailspring
      nextcloud-client
      spotify
      teams
      telegram-desktop
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
