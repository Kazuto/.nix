{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.services.nix-daemon;
in
{
  options.shiro.services.nix-daemon = {
    enable = mkBoolOpt false "Whether to enable the Nix daemon.";
  };

  config = mkIf cfg.enable {
    nix.enable = true;
  };
}