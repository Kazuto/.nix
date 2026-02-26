{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.jira-cli;
in
{
  options.shiro.cli.jira-cli = with types; {
    enable = mkBoolOpt false "Whether or not to install jira-cli";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ jira-cli-go ];
  };
}
