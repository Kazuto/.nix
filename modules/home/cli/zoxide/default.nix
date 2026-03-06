{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.zoxide;
in
{
  options.shiro.cli.zoxide = with types; {
    enable = mkBoolOpt false "Whether or not to install zoxide";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ zoxide ];
  };
}
