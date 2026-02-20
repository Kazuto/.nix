{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.blueutil;
in
{
  options.shiro.cli.blueutil = with types; {
    enable = mkBoolOpt false "Whether or not to install blueutil";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ blueutil ];
  };
}
