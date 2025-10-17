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
        jira-cli = enabled;
        neovim = enabled;
        ngrok = enabled;
        phpstan = enabled;
        trash = enabled;
        vercel = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        bun = enabled;
        # ghostty = enabled;
        gh-ost = enabled;
        git = enabled;
        pocketbase = enabled;
        vscode = enabled;
        sqlite = enabled;
      };

      development.languages = {
        lua = enabled;
        go = enabled;
      };
    };
  };
}
