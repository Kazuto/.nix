{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.nodejs;
in
{
  options.shiro.development.languages.nodejs = with types; {
    enable = mkBoolOpt false "Whether or not to install Node.js.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs_24
      prettierd
      nodePackages.eslint_d
      nodePackages.postcss
      vscode-extensions.vue.volar
      yalc
    ];
  };
}


