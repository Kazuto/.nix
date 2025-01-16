{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.wget;
in
{
  options.${namespace}.cli.wget = with types; {
    enable = mkBoolOpt false "Whether or not to install wget";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wget ];
  };
}
