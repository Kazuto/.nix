{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.wget;
in
{
  options.shiro.cli.wget = with types; {
    enable = mkBoolOpt false "Whether or not to install wget cli";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wget ];
  };
}
