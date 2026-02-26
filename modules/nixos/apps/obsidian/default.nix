{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.obsidian;
in
{
  options.shiro.apps.obsidian = with types; {
    enable = mkBoolOpt false "Whether or not to install obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ obsidian ];
  };
}
