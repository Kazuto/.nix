{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.dbeaver;
in
{
  options.shiro.development.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to install Dbeaver.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dbeaver ];
  };
}


