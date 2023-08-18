{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.tools.beekeeper;
in
{
  options.shiro.development.tools.beekeeper = with types; {
    enable = mkBoolOpt false "Whether or not to install Beekeeper Studio.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ beekeeper-studio ];
  };
}


