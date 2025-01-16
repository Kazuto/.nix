{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.curl;
in
{
  options.${namespace}.cli.curl = with types; {
    enable = mkBoolOpt false "Whether or not to install curl";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ curl ];
  };
}
