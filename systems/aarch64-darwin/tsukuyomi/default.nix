{ pkgs, lib, ... }:

with lib;
{
  # imports = [ ./hardware.nix ];

  shiro = {
    nix = enabled;

    cli = {
      ripgrep = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  environment.systemPackages = with pkgs; [
    snowfallorg.flake
    # raycast
    # skhd
  ];

  system.stateVersion = "23.05";
}
