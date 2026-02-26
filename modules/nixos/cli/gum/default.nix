{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.gum;
in
{
  options.shiro.cli.gum = with types; {
    enable = mkBoolOpt false "Whether or not to install gum";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gum ];
  };
}
