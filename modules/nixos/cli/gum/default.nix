{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.gum;
in
{
  options.${namespace}.cli.gum = with types; {
    enable = mkBoolOpt false "Whether or not to install gum";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gum ];
  };
}
