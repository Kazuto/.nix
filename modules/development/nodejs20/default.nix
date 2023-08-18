{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.nodejs20;
in
{
  options.shiro.development.nodejs20 = with types; {
    enable = mkBoolOpt false "Whether or not to install Node.js 20.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      nodejs_20
      nodePackages.eslint_d
      nodePackages.postcss
      nodePackages.prettier_d_slim
      nodePackages.vercel
      nodePackages.volar
      nodePackages.yarn
    ];
  };
}


