{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.gh;
in
{
  options.shiro.cli.gh = with types; {
    enable = mkBoolOpt false "Whether or not to install the GitHub CLI.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gh ];

    xdg.configFile."gh/config.yml".text = ''
      git_protocol: https
      editor:
      prompt: enabled
      pager:
      aliases:
        co: pr checkout
      http_unix_socket:
      browser:
      version: "1"
    '';

    xdg.configFile."gh/hosts.yml".text = ''
      github.com:
        user: Kazuto
        git_protocol: ssh
        users:
          Kazuto:
    '';
  };
}
