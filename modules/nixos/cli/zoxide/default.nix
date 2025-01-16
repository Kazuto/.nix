{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.zoxide;
in
{
  options.${namespace}.cli.zoxide = with types; {
    enable = mkBoolOpt false "Whether or not to install zoxide cli";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ zoxide ];
  };
}
