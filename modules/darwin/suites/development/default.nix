{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.development;
in
{
  options.shiro.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      apps = {
        obsidian = enabled;
      };

      cli = {
        git = enabled;
        jira-cli = enabled;
        neovim = enabled;
        phpstan = enabled;
        tmux = enabled;
        trash = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        bun = enabled;
        # ghostty = enabled;
        gh-ost = enabled;
        pocketbase = enabled;
        vscode = enabled;
        sqlite = enabled;
        opencode = enabled;
      };

      development.languages = {
        lua = enabled;
        go = enabled;
        rust = enabled;
      };
    };
  };
}
