{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.ripgrep;
in
{
  options.${namespace}.cli.ripgrep = with types; {
    enable = mkBoolOpt false "Whether or not to install ripgrep";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ripgrep ];
  };
}
