{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.phpstorm;
in
{
  options.${namespace}.development.tools.phpstorm = with types; {
    enable = mkBoolOpt false "Whether or not to install phpstorm.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jetbrains.phpstorm ];
  };
}


