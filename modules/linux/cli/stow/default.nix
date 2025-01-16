{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.stow;
in
{
  options.${namespace}.cli.stow = with types; {
    enable = mkBoolOpt false "Whether or not to install stow";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ stow ];
  };
}
