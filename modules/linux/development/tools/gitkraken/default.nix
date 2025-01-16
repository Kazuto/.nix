{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.gitkraken;
in
{
  options.${namespace}.development.tools.gitkraken = with types; {
    enable = mkBoolOpt false "Whether or not to install Gitkraken.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gitkraken ];
  };
}


