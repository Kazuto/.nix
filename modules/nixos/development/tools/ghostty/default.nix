{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.ghostty;
in
{
  options.shiro.development.tools.ghostty = with types; {
    enable = mkBoolOpt false "Whether or not to install ghostty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ghostty ];

    # shiro.home.configFile."ghostty/config".source = ./config;
  };
}


