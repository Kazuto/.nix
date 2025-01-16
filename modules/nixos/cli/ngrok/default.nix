{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.ngrok;
in
{
  options.${namespace}.cli.ngrok = with types; {
    enable = mkBoolOpt false "Whether or not to install ngrok";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ngrok ];
  };
}
