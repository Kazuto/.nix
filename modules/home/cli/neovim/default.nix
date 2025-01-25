{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "cli"
    "neovim"
  ];

  output = {
    environment.variables = {
      EDITOR = "nvim";
    };

    config.${namespace}.home.extraOptions = {
      programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
      };

      programs.fzf.enable = true;

      # programs.zsh.shellAliases.vim = "nvim";
      # programs.bash.shellAliases.vim = "nvim";
    };

    shiro = {
      development.languages.nodejs20 = enabled;
      cli.ripgrep = enabled;
    };

    environment.systemPackages = with pkgs; [
      neovim

      ctags
      codespell
      editorconfig-checker
      gopls
      languagetool
      lua-language-server
      phpactor
      shellcheck
      stylua
      tree-sitter

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