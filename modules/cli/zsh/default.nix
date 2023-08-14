{ lib, config, ... }:

let
  cfg = config.shiro.cli.zsh;
in
{
  options.shiro.cli.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to install zsh";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      oh-my-zsh
      zsh
      zsh-powerlevel10k

      # Tools needed for aliases
      bat
      exa
      trashy
      tree
      xclip
    ];

    shiro.home = {
      file = {
        ".p10k.zsh" = {
          source = ./.p10k.zsh;
          executable = true;
        };

        ".aliases" = {
          source = ./.aliases;
          executable = false;
        };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
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
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
            { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
          ];
        };
      };
    };
  };
}
