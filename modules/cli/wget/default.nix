{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.wget;
in
{
  options.shiro.cli.wget = with types; {
    enable = mkBoolOpt false "Whether or not to install wget";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wget ];
  };
}
