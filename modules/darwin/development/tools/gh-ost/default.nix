{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.gh-ost;
in
{
  options.shiro.development.tools.gh-ost = with types; {
    enable = mkBoolOpt false "Whether or not to install gh-ost.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gh-ost ];
  };
}


