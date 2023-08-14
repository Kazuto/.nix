{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.cli.fzf;
in
{
  options.shiro.cli.fzf = with types; {
    enable = mkBoolOpt false "Whether or not to install fzf";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fzf ];
  };
}
