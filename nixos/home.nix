{ config, pkgs, ... }:

{
  home = {
    username = "kazuto";
    homeDirectory = "/home/kazuto";

    stateVersion = "23.05";

    packages = with pkgs; [
      # Applications
      bitwarden
      brave
      discord
      firefox-wayland
      mailspring
      nextcloud-client
      spotify
      teams
      telegram-desktop

      # Development
      beekeper-studio
      codespell
      commitizen
      dbeaver
      docker
      docker-compose
      editorconfig-checker
      fd
      gh
      gitkraken
      insomnia
      jetbrains.phpstorm
      kitty
      neovim
      nodejs_20
      nodePackages.eslint_d
      nodePackages.npm
      nodePackages.postcss
      nodePackages.prettier_d_slim
      nodePackages.vercel
      nodePackages.volar
      nodePackages.yarn
      oh-my-zsh

      (php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug imagick
        ]));
        extraConfig = ''
          memory_limit = 8G
          IDE Key = nvim
          xdebug.mode = debug
        '';
      })

      php81Packages.composer
      php81Extensions.imagick
      postman
      pre-commit
      shellcheck
      skeema
      supabase-cli
      trash-cli
      tree
      vimPlugins.codeium-vim
      vscode
      zsh-powerlevel10k
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
