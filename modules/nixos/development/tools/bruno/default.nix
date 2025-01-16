{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.bruno;
in
{
  options.${namespace}.development.tools.bruno = with types; {
    enable = mkBoolOpt false "Whether or not to install bruno";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bruno ];
  };
}
