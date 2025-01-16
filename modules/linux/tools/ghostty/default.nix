{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.ghostty;
in
{
  options.shiro.tools.ghostty = with types; {
    enable = mkBoolOpt false "Whether or not to install Ghostty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ghostty ];
  };
}


