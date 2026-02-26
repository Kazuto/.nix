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
        coreutils = enabled;
        flake = enabled;
        stow = enabled;
        neofetch = enabled;
        wget = enabled;
      };

      services = {
        nix-daemon = enabled;
      };

      system = {
        fonts = enabled;
        interface = enabled;
      };
    };
  };
}
