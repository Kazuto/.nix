{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.flake;
in
{
  options.shiro.cli.flake = with types; {
    enable = mkBoolOpt false "Whether or not to install flake";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ snowfallorg.flake ];
  };
}
