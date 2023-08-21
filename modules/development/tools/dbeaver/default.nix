{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.dbeaver;
in
{
  options.shiro.development.tools.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to install Dbeaver.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dbeaver ];
  };
}


