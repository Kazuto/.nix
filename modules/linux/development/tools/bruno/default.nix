{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.bruno;
in
{
  options.shiro.development.tools.bruno = with types; {
    enable = mkBoolOpt false "Whether or not to install bruno";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bruno ];
  };
}
