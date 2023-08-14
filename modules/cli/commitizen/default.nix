{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.commitizen;
in
{
  options.shiro.cli.commitizen = with types; {
    enable = mkBoolOpt false "Whether or not to install Commitizen";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ commitizen ];
  };
}
