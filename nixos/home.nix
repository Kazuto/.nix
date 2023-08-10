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

    file = {
      ".p10k.zsh" = {
        source = ../.config/zsh/.p10k.zsh;
        executable = true;
      };

      ".aliases" = {
        source = ../.config/zsh/.aliases;
        executable = false;
      };
    };

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

      # Utilities
      bat
      btop
      busybox
      fzf
      exa
      gparted
      neofetch
      qemu_kvm
      ripgrep
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Kazuto";
    userEmail = "mail@kazuto.de";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      [[ ! -f ~/.aliases ]] || source ~/.aliases
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
      ];
    };
  };

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
