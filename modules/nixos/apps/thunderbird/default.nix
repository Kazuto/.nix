{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.thunderbird;
in
{
  options.shiro.apps.thunderbird = with types; {
    enable = mkBoolOpt false "Whether or not to install Thunderbird.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ thunderbird ];
  };
}
