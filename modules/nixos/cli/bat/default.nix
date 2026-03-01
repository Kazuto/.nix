{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.bat;
in
{
  options.shiro.cli.bat = with types; {
    enable = mkBoolOpt false "Whether or not to install bat";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bat ];
  };
}
