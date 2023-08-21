{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.tmux;
in
{
  options.shiro.cli.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to install tmux";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tmux ];

    shiro.home.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };
}
