{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.nix;
in
{
  options.shiro.nix = with types; {
    enable = mkBoolOpt false "Whether or not to manage nix configuration.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  };
}



