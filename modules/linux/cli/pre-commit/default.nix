{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.pre-commit;
in
{
  options.${namespace}.cli.pre-commit = with types; {
    enable = mkBoolOpt false "Whether or not to install pre-commit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pre-commit ];
  };
}
