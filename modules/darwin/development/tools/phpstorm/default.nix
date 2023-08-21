{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.phpstorm;
in
{
  options.shiro.development.tools.phpstorm = with types; {
    enable = mkBoolOpt false "Whether or not to install phpstorm.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jetbrains.phpstorm ];
  };
}


