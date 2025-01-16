{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = with types; {
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
        neovim = enabled;
        ngrok = enabled;
        phpstan = enabled;
        pre-commit = enabled;
        supabase = enabled;
        vercel = enabled;
        # wget = enabled;
        zoxide = enabled;
        zsh = enabled;
      };

      development.tools = {
        beekeeper = enabled;
        bruno = enabled;
        dbeaver = enabled;
        gitkraken = enabled;
        insomnia = enabled;
        kitty = enabled;
        phpstorm = enabled;
        vscode = enabled;
      };

      development.languages = {
        nodejs20 = enabled;
        php81 = enabled;
        python311 = enabled;
        go = enabled;
      };

      tools = {
        git = enabled;
      };
    };
  };
}
