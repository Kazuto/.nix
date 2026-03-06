{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.lua;
in
{
  options.shiro.development.languages.lua = with types; {
    enable = mkBoolOpt false "Whether or not to use Lua";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      luajit
    ];
  };
}
