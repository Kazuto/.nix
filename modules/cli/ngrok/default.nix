{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.ngrok;
in
{
  options.shiro.cli.ngrok = with types; {
    enable = mkBoolOpt false "Whether or not to install ngrok";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ngrok ];
  };
}
