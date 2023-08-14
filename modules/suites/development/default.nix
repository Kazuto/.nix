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
      development = {
        beekeeper = enabled;
        dbeaver = enabled;
        gitkraken = enabled;
        insomnia = enabled;
        kitty = enabled;
        nodejs20 = enabled;
        php81 = enabled;
        phpstorm = enabled;
        python311 = enabled;
        postman = enabled;
        vscode = enabled;
      };

      cli = {
        codespell = enabled;
        commitizen = enabled;
        curl = enabled;
        editorconfig-checker = enabled;
        fzf = enabled;
        neovim = enabled;
        pre-commit = enabled;
        shellcheck = enabled;
        skeema = enabled;
        supabase = enabled;
        wget = enabled;
        zsh = enabled;
      };

      tools = {
        git = enabled;
      };
    };
  };
}
