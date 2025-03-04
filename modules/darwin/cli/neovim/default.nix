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

    shiro.development.languages.nodejs20 = enabled;
    shiro.cli.ripgrep = enabled;

    environment.systemPackages = with pkgs; [
      neovim

      ctags
      codespell
      editorconfig-checker
      fd
      fzf
      gopls
      languagetool
      lazygit
      lua-language-server
      phpactor
      ripgrep
      shellcheck
      stylua
      tree-sitter
      silicon

      nodePackages.bash-language-server
      nodePackages.diagnostic-languageserver
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.eslint_d
      nodePackages.tailwindcss
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
    ];
  };
}
