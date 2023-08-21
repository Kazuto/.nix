{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.vscode;
in
{
  options.shiro.development.tools.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to install Visual Studio Code.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vscode ];
  };
}


