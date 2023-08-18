{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.neovim;
in
{
  options.shiro.cli.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to install neovim";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim";
    };

    shiro.home.extraOptions = {
      programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
      };

      programs.fzf.enable = true;

      # programs.zsh.shellAliases.vim = "nvim";
      # programs.bash.shellAliases.vim = "nvim";
    };

    shiro.development.nodejs20 = enabled;
    shiro.cli.ripgrep = enabled;

    environment.systemPackages = with pkgs; [
      ctags
      codespell
      editorconfig-checker
      shellcheck
      languagetool
      tree-sitter

      nodePackages.bash-language-server
      nodePackages.diagnostic-languageserver
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.tailwindcss
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver-bin
      nodePackages.yaml-language-server
    ];
  };
}
