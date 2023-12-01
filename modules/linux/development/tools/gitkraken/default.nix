{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.gitkraken;
in
{
  options.shiro.development.tools.gitkraken = with types; {
    enable = mkBoolOpt false "Whether or not to install Gitkraken.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gitkraken ];
  };
}


