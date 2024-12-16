{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.nodejs20;
in
{
  options.shiro.development.languages.nodejs20 = with types; {
    enable = mkBoolOpt false "Whether or not to install Node.js 20.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      nodejs_20
      nodePackages.eslint_d
      nodePackages.postcss
      nodePackages.vercel
      vscode-extensions.vue.volar
      nodePackages.yarn
    ];
  };
}


