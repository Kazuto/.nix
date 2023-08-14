{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.development.nodejs;
in
{
  options.shiro.development.nodejs = with types; {
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


