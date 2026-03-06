{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.zsh;
in
{
  options.shiro.cli.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to enable zsh system-wide";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
