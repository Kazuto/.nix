{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.neofetch;
in
{
  options.shiro.cli.neofetch = with types; {
    enable = mkBoolOpt false "Whether or not to install neofetch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neofetch ];
  };
}
