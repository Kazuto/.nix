{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.development.vscode;
in
{
  options.shiro.development.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to install Visual Studio Code.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vscode ];
  };
}


