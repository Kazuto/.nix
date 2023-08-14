{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.development.phpstorm;
in
{
  options.shiro.development.phpstorm = with types; {
    enable = mkBoolOpt false "Whether or not to install phpstorm.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jetbrains.phpstorm ];
  };
}


