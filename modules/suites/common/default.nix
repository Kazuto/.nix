{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.suites.common;
in
{
  options.shiro.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      hardware = {
        audio = enabled;
        network = enabled;
      };
    };

    environment.systemPackages = with pkgs; [
      killall
      gcc
      gnumake
      pkg-config
      xorg.xhost
    ];
  };
}
