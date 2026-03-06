{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.fastfetch;
in
{
  options.shiro.cli.fastfetch = with types; {
    enable = mkBoolOpt false "Whether or not to install fastfetch";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ fastfetch ];
  };
}
