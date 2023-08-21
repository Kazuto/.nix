{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.raycast;
in
{
  options.shiro.apps.raycast = with types; {
    enable = mkBoolOpt false "Whether or not to install raycast";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ raycast ];
  };
}
