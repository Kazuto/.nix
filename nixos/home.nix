{ config, pkgs, ... }:

let
    myPkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/e2911d022051066f6db6458b95a13f5e259f13b1.tar.gz";
    }) {};
in
{
  gtk = {
    enable = true;

    theme = {
      name = "Juno";
      package = pkgs.juno-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Amber";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Papirus Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

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

  services.mysql = {
    enable = true;
    package = myPkgs.mysql57;
    ensureUsers = [
      {
        name = "root";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.redis = {
    servers."default" = {
      enable = true;
    };
  };
}
