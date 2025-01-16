{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.beekeeper;
in
{
  options.${namespace}.development.tools.beekeeper = with types; {
    enable = mkBoolOpt false "Whether or not to install Beekeeper Studio.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ beekeeper-studio ];
  };
}


