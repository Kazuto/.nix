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

      development.tools = {
        git = enabled;
        gitkraken = enabled;
        # insomnia = enabled;
        kitty = enabled;
        phpstorm = enabled;
        postman = enabled;
        vscode = enabled;
      };

      development.languages = {
        nodejs20 = enabled;
        php81 = enabled;
        python311 = enabled;
      };

      cli = {
        commitizen = enabled;
        neovim = enabled;
        ngrok = enabled;
        pre-commit = enabled;
        supabase = enabled;
        trash = enabled;
        vercel = enabled;
        zsh = enabled;
      };
    };
  };
}
