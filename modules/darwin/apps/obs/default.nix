{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.obs;
in
{
  options.shiro.apps.obs = with types; {
    enable = mkBoolOpt false "Whether or not to install OBS Studio.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ obs-studio ];
  };
}
