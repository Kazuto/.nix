{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.apps.remmina;
in
{
  options.shiro.apps.remmina = with types; {
    enable = mkBoolOpt false "Whether or not to install remmina";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ remmina ];
  };
}
