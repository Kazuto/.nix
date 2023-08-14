{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.curl;
in
{
  options.shiro.cli.curl = with types; {
    enable = mkBoolOpt false "Whether or not to install curl";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ curl ];
  };
}
