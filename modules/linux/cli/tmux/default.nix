{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.tmux;
in
{
  options.${namespace}.cli.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to install tmux";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tmux ];

    shiro.home.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };
}
