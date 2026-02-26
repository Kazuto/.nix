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
        commitizen = enabled;
        curl = enabled;
        gum = enabled;
        jira-cli = enabled;
        neovim = enabled;
        ngrok = enabled;
        phpstan = enabled;
        pre-commit = enabled;
        supabase = enabled;
        tmux = enabled;
        vercel = enabled;
        # wget = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        beekeeper = enabled;
        bruno = enabled;
        bun = enabled;
        dbeaver = enabled;
        gitkraken = enabled;
        insomnia = enabled;
        kitty = enabled;
        phpstorm = enabled;
        vscode = enabled;
      };

      development.languages = {
        nodejs = enabled;
        php8 = enabled;
        python311 = enabled;
        go = enabled;
      };

      tools = {
        git = enabled;
      };
    };
  };
}
