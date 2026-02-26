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
        curl = enabled;
        git = enabled;
        gum = enabled;
        jira-cli = enabled;
        neovim = enabled;
        phpstan = enabled;
        pre-commit = enabled;
        tmux = enabled;
        # wget = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        bruno = enabled;
        bun = enabled;
        kitty = enabled;
        lmstudio = enabled;
        ollama = enabled;
        tableplus = enabled;
        vscode = enabled;
      };

      development.languages = {
        nodejs = enabled;
        php8 = enabled;
        python311 = enabled;
        go = enabled;
      };
    };
  };
}
