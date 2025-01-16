{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.dbeaver;
in
{
  options.${namespace}.development.tools.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to install Dbeaver.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dbeaver ];
  };
}


