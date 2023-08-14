{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.cli.ripgrep;
in
{
  options.shiro.cli.ripgrep = with types; {
    enable = mkBoolOpt false "Whether or not to install ripgrep";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ripgrep ];
  };
}
