{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.steam;
in
{
  options.shiro.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to install steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ steam ];
  };
}
