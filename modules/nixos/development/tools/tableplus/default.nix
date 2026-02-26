{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.tableplus;
in
{
  options.shiro.development.tools.tableplus = with types; {
    enable = mkBoolOpt false "Whether or not to install TablePlus.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tableplus ];
  };
}
