{ options, config, lib, pkgs, osConfig ? null, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.zsh;

  # Get hostname from system config if available, otherwise use environment variable
  hostname = if osConfig != null && osConfig ? networking then osConfig.networking.hostName else "$HOST";

  configFiles = [
    "${config.programs.zsh.dotDir}/.aliases"
    "${config.programs.zsh.dotDir}/.after"
    "${config.home.homeDirectory}/.p10k.zsh"
  ];
in
{
  options.shiro.cli.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to configure zsh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      oh-my-zsh
      zsh-powerlevel10k
      bat
      eza
      tree
      zoxide
    ] ++ lib.optionals stdenv.isDarwin [ darwin.trash ]
      ++ lib.optionals stdenv.isLinux [ trashy xclip ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.composer/vendor/bin"
      "$PYENV_ROOT/bin"
      "${config.home.homeDirectory}/.spicetify"
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
      "${config.home.homeDirectory}/Library/Application Support/Herd/bin"
    ];

    programs.zsh.shellAliases = {
      # File operations
      rm = if pkgs.stdenv.isDarwin then "trash" else "trashy";
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

      # Navigation
      cd = "z";

      # Editors
      vim = "nvim";

      # Terminal
      c = "clear";
      s = "source ${config.programs.zsh.dotDir}/.zshrc";

      # Config shortcuts
      config = "cd ${config.xdg.configHome} && nvim";
      nixconf = "cd ${config.home.homeDirectory}/.nix && nvim";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      # Nix rebuild alias for cross-platform compatibility
      nixos-rebuild = "darwin-rebuild";
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      # Clipboard aliases for Linux (xclip)
      pbcopy = "xclip -sel clip";
      pbpaste = "xclip -sel clip -o";
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
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

      sessionVariables = {
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
      } // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Herd PHP (macOS only)
        HERD_PHP_84_INI_SCAN_DIR = "${config.home.homeDirectory}/Library/Application Support/Herd/config/php/84/";
        HERD_PHP_82_INI_SCAN_DIR = "${config.home.homeDirectory}/Library/Application Support/Herd/config/php/82/";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "composer" "npm" ];
        theme = "powerlevel10k/powerlevel10k";
        custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
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
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      initContent = lib.mkMerge [
        (lib.mkBefore ''
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '')
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
          ${if pkgs.stdenv.isDarwin
            then "sudo darwin-rebuild switch --flake ${config.home.homeDirectory}/.nix/#${hostname}"
            else "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/.nix/#${hostname}"}
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
        command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        command -v pyenv &>/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"
        command -v tmuxifier &>/dev/null && eval "$(tmuxifier init -)"

        # Load zsh functions
        autoload -U add-zsh-hook
        ''
      ];
    };
  };
}
