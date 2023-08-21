{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.common;
in
{
  options.shiro.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      nix = enabled;

      cli = {
        flake = enabled;
        stow = enabled;
      };

      hardware = {
        audio = enabled;
        network = enabled;
      };

      services = {
        openssh = enabled;
        printing = enabled;
        dbus = enabled;
      };

      system = {
        boot = enabled;
        env = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };

    environment.systemPackages = with pkgs; [
      killall
      gcc
      gnumake
      pkg-config
      xorg.xhost
      snowfallorg.flake
    ];
  };
}
