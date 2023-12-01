{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.ghostscript;
in
{
  options.shiro.development.tools.ghostscript = with types; {
    enable = mkBoolOpt false "Whether or not to install ghostscript.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ghostscript ];
  };
}


