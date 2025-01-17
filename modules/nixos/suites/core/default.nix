{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.core;
in
{
  options.${namespace}.suites.core = with types; {
    enable = mkBoolOpt false "Whether or not to enable core configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      nix = enabled;

      cli = {
        flake = enabled;
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

      tools = {
        git = enabled;
      }
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
