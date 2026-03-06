{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.zsh;
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
    ] ++ lib.optionals stdenv.isDarwin [ darwin.trash ]
      ++ lib.optionals stdenv.isLinux [ trashy ];

    programs.zsh.shellAliases.rm =
      if pkgs.stdenv.isDarwin then "trash" else "trashy";

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;

      dotDir = "${config.home.homeDirectory}/.config/zsh";

      history = {
        size = 10000;
        path = "$XDG_DATA_HOME/zsh/history";
      };

      initContent = ''
        [[ ! -f ~/.aliases ]] || source ~/.aliases
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        export EDITOR="nvim"
        export TERM="ghostty"
        export TERMINAL="ghostty"
        export PROJECT_ROOT="$HOME/Development"

        # Nvim
        export NVIM_LARAVEL_ENV=local

        # LM Studio
        export LMSTUDIO_BASE_URL="http://localhost:1234"
      '';

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
        ];
      };
    };
  };
}
