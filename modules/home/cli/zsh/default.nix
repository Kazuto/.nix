{
  options,
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
with lib;
with lib.shiro; let
  cfg = config.shiro.cli.zsh;

  # Get hostname from system config if available, otherwise use environment variable
  hostname =
    if osConfig != null && osConfig ? networking
    then osConfig.networking.hostName
    else "$HOST";

  configFiles = [
    "${config.programs.zsh.dotDir}/.aliases"
    "${config.programs.zsh.dotDir}/.after"
    # "${config.home.homeDirectory}/.p10k.zsh"  # Disabled while testing Starship
  ];
in {
  options.shiro.cli.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to configure zsh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        oh-my-zsh
        zsh-powerlevel10k
        bat
        eza
        tree
        zoxide
      ]
      ++ lib.optionals stdenv.isDarwin [darwin.trash]
      ++ lib.optionals stdenv.isLinux [trash-cli xclip];

    home.sessionPath =
      [
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.homeDirectory}/.cargo/bin"
        "${config.home.homeDirectory}/.composer/vendor/bin"
        "$PYENV_ROOT/bin"
        "${config.home.homeDirectory}/.spicetify"
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "${config.home.homeDirectory}/Library/Application Support/Herd/bin"
      ];

    programs.zsh.shellAliases =
      {
        # File operations
        rm =
          if pkgs.stdenv.isDarwin
          then "trash"
          else "trash-put";
        cat = "bat --paging=never";
        ls = "eza --icons";
        l = "ls -lah";

        # Auth
        token = "pwgen -s 40 1 | pbcopy && echo 'Copied to clipboard.'";
        password = "pwgen -s 24 1 | pbcopy && echo 'Copied to clipboard.'";
        uuid = "uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy && echo 'Copied to clipboard.'";

        # Git
        lg = "lazygit";
        nah = "git stash && git stash drop";

        # Laravel
        art = "php artisan";

        # Navigation (handled by zoxide --cmd cd below)
        # cd = "z";  # Removed - using zoxide --cmd cd instead

        # Editors
        vim = "nvim";

        # Terminal
        c = "clear";
        s = "source ${config.programs.zsh.dotDir}/.zshrc";

        # Config shortcuts
        config = "cd ${config.xdg.configHome} && nvim";
        nixconf = "cd ${config.home.homeDirectory}/.nix && nvim";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Nix rebuild alias for cross-platform compatibility
        nixos-rebuild = "darwin-rebuild";
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        # Clipboard aliases for Linux (xclip)
        pbcopy = "xclip -sel clip";
        pbpaste = "xclip -sel clip -o";
      };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Starship prompt - Simple config with Catppuccin Mocha colors
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        # Disable newline before prompt
        add_newline = false;

        # Simple format: os, directory, git, newline, prompt
        format = lib.concatStrings [
          "$os"
          "$directory"
          "$git_branch"
          "$git_status"
          "$line_break"
          "$character"
        ];

        # Right prompt: status, duration, jobs, versions
        right_format = lib.concatStrings [
          "$status"
          "$cmd_duration"
          "$jobs"
          "$python"
          "$nodejs"
          "$php"
          "$ruby"
          "$golang"
          "$rust"
        ];

        # OS icon
        os = {
          disabled = false;
          format = "[$symbol ]($style)";
          style = "bold red";
          symbols = {
            Windows = "";
            Ubuntu = "󰕈";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Arch = "󰣇";
            NixOS = "󱄅";
          };
        };

        # Directory
        directory = {
          format = "[$path]($style) ";
          style = "bold peach";
          truncation_length = 3;
          truncate_to_repo = true;
        };

        # Git branch
        git_branch = {
          format = "on [$symbol$branch]($style) ";
          style = "bold mauve";
          symbol = " ";
        };

        # Git status
        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
          style = "bold yellow";
          modified = "!\${count}";
          untracked = "?\${count}";
          deleted = "✘\${count}";
          renamed = "»\${count}";
          staged = "+\${count}";
          stashed = "\\$\${count}";
        };

        # Status
        status = {
          disabled = false;
          format = "[$symbol$status ]($style)";
          style = "bold red";
          symbol = "✘ ";
        };

        # Command duration
        cmd_duration = {
          min_time = 2000;
          format = "[$duration ]($style)";
          style = "bold yellow";
        };

        # Background jobs
        jobs = {
          format = "[$symbol$number ]($style)";
          symbol = "✦ ";
          style = "bold blue";
        };

        # Character (prompt symbol)
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };

        # Language versions
        python = {
          format = "[\${symbol}\${version} ]($style)";
          style = "yellow";
          symbol = " ";
        };

        nodejs = {
          format = "[\${symbol}\${version} ]($style)";
          style = "green";
          symbol = " ";
        };

        php = {
          format = "[\${symbol}\${version} ]($style)";
          style = "blue";
          symbol = " ";
        };

        ruby = {
          format = "[\${symbol}\${version} ]($style)";
          style = "red";
          symbol = " ";
        };

        golang = {
          format = "[\${symbol}\${version} ]($style)";
          style = "sapphire";
          symbol = " ";
        };

        rust = {
          format = "[\${symbol}\${version} ]($style)";
          style = "peach";
          symbol = " ";
        };

        docker_context = {
          format = "[\${symbol}\${version} ]($style)";
          style = "blue";
          symbol = "";
        };

        # Catppuccin Mocha palette
        palette = "catppuccin_mocha";

        palettes = {
          catppuccin_mocha = {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#f38ba8";
            maroon = "#eba0ac";
            peach = "#fab387";
            yellow = "#f9e2af";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#89b4fa";
            lavender = "#b4befe";
            text = "#cdd6f4";
            subtext1 = "#bac2de";
            subtext0 = "#a6adc8";
            overlay2 = "#9399b2";
            overlay1 = "#7f849c";
            overlay0 = "#6c7086";
            surface2 = "#585b70";
            surface1 = "#45475a";
            surface0 = "#313244";
            base = "#1e1e2e";
            mantle = "#181825";
            crust = "#11111b";
          };
        };
      };
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;

      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        size = 10000;
        path = "$XDG_DATA_HOME/zsh/history";
      };

      sessionVariables =
        {
          EDITOR = "nvim";
          TERM = "ghostty";
          TERMINAL = "ghostty";
          PROJECT_ROOT = "${config.home.homeDirectory}/Development";

          # Nvim
          NVIM_LARAVEL_ENV = "local";

          # LM Studio
          LMSTUDIO_BASE_URL = "http://localhost:1234";

          ANTHROPIC_MODEL = "claude-sonnet-4-5-20250929";

          # Pyenv
          PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";

          # Tmuxifier
          TMUXIFIER_LAYOUT_PATH = "${config.xdg.configHome}/tmuxifier/layouts";

          # NVM
          NVM_DIR = "${config.home.homeDirectory}/.nvm";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          # Herd PHP (macOS only)
          HERD_PHP_84_INI_SCAN_DIR = "${config.home.homeDirectory}/Library/Application Support/Herd/config/php/84/";
          HERD_PHP_82_INI_SCAN_DIR = "${config.home.homeDirectory}/Library/Application Support/Herd/config/php/82/";
        };

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "composer" "npm"];
        # Powerlevel10k loaded as plugin below instead of oh-my-zsh theme
      };

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
        # Temporarily disabled to test Starship
        # {
        #   name = "powerlevel10k";
        #   src = pkgs.zsh-powerlevel10k;
        #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
      ];

      initContent = lib.mkMerge [
        # Powerlevel10k instant prompt disabled while testing Starship
        # (lib.mkBefore ''
        #   # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        #   # Initialization code that may require console input (password prompts, [y/n]
        #   # confirmations, etc.) must go above this block; everything else may go below.
        #   if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        #     source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
        #   fi
        # '')
        ''
          # Key bindings
          bindkey "^[[3~" delete-char              # Delete key
          bindkey "^[[H" beginning-of-line         # Home key
          bindkey "^[[F" end-of-line               # End key
          bindkey "^[[1;5C" forward-word           # Ctrl+Right
          bindkey "^[[1;5D" backward-word          # Ctrl+Left
          bindkey "^?" backward-delete-char        # Backspace

          # Custom functions
          # Create directory and move to it
          function to() {
            mkdir -p "$1"
            cd "$1" || true
          }

          # Tmuxifier shortcuts
          function tls() {
            tmuxifier load-session "$1"
          }

          function tms() {
            tmuxifier new-session "$1"
          }

          # Nix rebuild shortcut
          function nix:update() {
            echo "Rebuilding flake ./#${hostname}"
            ${
            if pkgs.stdenv.isDarwin
            then "sudo darwin-rebuild switch --flake ${config.home.homeDirectory}/.nix/#${hostname}"
            else "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/.nix/#${hostname}"
          }
          }

          # Docker shortcuts
          function dcu() {
            local -a env_args=()
            [ -n "$1" ] && env_args=(--env-file "$1")
            docker compose "''${env_args[@]}" up -d --force-recreate --remove-orphans
          }

          function dcupdate() {
            local -a env_args=()
            [ -n "$1" ] && env_args=(--env-file "$1")
            docker compose "''${env_args[@]}" up -d --force-recreate --pull always
          }

          # Source additional config files
          for file in ${lib.concatStringsSep " " configFiles}; do
            [[ -f "$file" ]] && source "$file"
          done

          # Tool initializations
          command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"
          # command -v pyenv &>/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"  # Disabled - causes hang
          command -v tmuxifier &>/dev/null && eval "$(tmuxifier init -)"

          # Lazy load pyenv to avoid startup hang
          if command -v pyenv &>/dev/null; then
            export PYENV_ROOT="$HOME/.pyenv"
            export PATH="$PYENV_ROOT/bin:$PATH"
            pyenv() {
              unset -f pyenv
              eval "$(command pyenv init --path)"
              eval "$(command pyenv init -)"
              pyenv "$@"
            }
          fi

          # Lazy load NVM to avoid startup hang
          if [ -s "$NVM_DIR/nvm.sh" ]; then
            # Create wrapper functions instead of aliases to avoid conflicts
            nvm() {
              unset -f nvm node npm
              \. "$NVM_DIR/nvm.sh"
              nvm "$@"
            }
            node() {
              unset -f nvm node npm
              \. "$NVM_DIR/nvm.sh"
              node "$@"
            }
            npm() {
              unset -f nvm node npm
              \. "$NVM_DIR/nvm.sh"
              npm "$@"
            }
          fi

          # Load zsh functions
          autoload -U add-zsh-hook
        ''
      ];
    };
  };
}
