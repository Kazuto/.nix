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
      luajit  # Use LuaJIT (faster, compatible with Lua 5.1)
      # lua     # Conflicts with luajit - both provide /bin/lua
    ];
  };
}
