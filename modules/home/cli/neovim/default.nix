{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.neovim;
in
{
  options.shiro.cli.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to install neovim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    programs.fzf.enable = true;

    home.packages = with pkgs; [
      ctags
      codespell
      editorconfig-checker
      fd
      fzf
      gopls
      languagetool
lua-language-server
      phpactor
      ripgrep
      shellcheck
      stylua
      tree-sitter
      silicon

      nodePackages.bash-language-server
      nodePackages.diagnostic-languageserver
      dockerfile-language-server
      nodePackages.eslint_d
      nodePackages.tailwindcss
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
    ];
  };
}
