{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.gh;
in
{
  options.shiro.cli.gh = with types; {
    enable = mkBoolOpt false "Whether or not to install the GitHub CLI.";
  };

  config = mkIf cfg.enable {
    # Just install gh, let it manage its own config
    home.packages = with pkgs; [ gh ];
  };
}
