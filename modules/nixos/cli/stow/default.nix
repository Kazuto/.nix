{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.stow;
in
{
  options.shiro.cli.stow = with types; {
    enable = mkBoolOpt false "Whether or not to install stow";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ stow ];
  };
}
