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
        gum = enabled;
        neovim = enabled;
        ngrok = enabled;
        phpstan = enabled;
        supabase = enabled;
        # tmux = enabled;
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
        gitkraken = enabled;
        pocketbase = enabled;
        kitty = enabled;
        phpstorm = enabled;
        vscode = enabled;
      };

      development.languages = {
        lua = enabled;
        nodejs20 = enabled;
        # php81 = enabled;
        # python311 = enabled;
        go = enabled;
      };
    };
  };
}
