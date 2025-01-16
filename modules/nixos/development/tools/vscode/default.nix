{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.tools.vscode;
in
{
  options.${namespace}.development.tools.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to install Visual Studio Code.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vscode ];
  };
}


