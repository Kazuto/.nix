{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.brave;
in
{
  options.shiro.apps.brave = with types; {
    enable = mkBoolOpt false "Whether or not to install Brave";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ brave ];
  };
}
