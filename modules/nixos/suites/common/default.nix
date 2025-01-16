{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      nix = enabled;

      cli = {
      	curl = enabled;
        flake = enabled;
        neovim = enabled;
        zsh = enabled;
      };

      tools = {
        ghostty = enabled;
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
