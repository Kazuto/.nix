{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.signal;
in
{
  options.shiro.apps.signal = with types; {
    enable = mkBoolOpt false "Whether or not to install Signal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ signal-desktop ];
  };
}
