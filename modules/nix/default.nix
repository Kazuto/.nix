{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.nix;
in
{
  options.shiro.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to install Hyprland and dependencies.";
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}



