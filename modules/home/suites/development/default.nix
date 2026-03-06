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
        gh = enabled;
        git = enabled;
        gum = enabled;
        lazygit = enabled;
        jira-cli = enabled;
        neovim = enabled;
        phpstan = enabled;
        pre-commit = enabled;
        skeema = enabled;
        tmux = enabled;
        zoxide = enabled;
      };

      development.tools = {
        bruno = enabled;
        bun = enabled;
        claude-code = enabled;
        ghostty = enabled;
        gh-ost = enabled;
        lmstudio = enabled;
        ollama = enabled;
        opencode = enabled;
        pyenv = enabled;
        sqlite = enabled;
        vscode = enabled;
      };

      development.languages = {
        go = enabled;
        lua = enabled;
        nodejs = enabled;
        php8 = enabled;
        python3 = enabled;
        rust = enabled;
      };
    };
  };
}
