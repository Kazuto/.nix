{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.languages.nodejs20;
in
{
  options.${namespace}.development.languages.nodejs20 = with types; {
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


