{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.homebrew;
in
{
  options.shiro.system.homebrew = with types; {
    enable = mkBoolOpt false "Whether or not to manage Homebrew declaratively for packages unavailable in nixpkgs.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        upgrade = false;
      };

      # Apple-proprietary packages unavailable in nixpkgs
      casks = [
        "sf-symbols"
        "font-sf-pro"
      ];
    };
  };
}
