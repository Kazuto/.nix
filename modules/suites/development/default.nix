{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.suites.development;
in
{
  options.shiro.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable development configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      development.tools = {
        beekeeper = enabled;
        dbeaver = enabled;
        gitkraken = enabled;
        insomnia = enabled;
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
        curl = enabled;
        neovim = enabled;
        ngrok = enabled;
        pre-commit = enabled;
        skeema = enabled;
        supabase = enabled;
        vercel = enabled;
        wget = enabled;
        zsh = enabled;
      };

      tools = {
        git = enabled;
      };
    };
  };
}
