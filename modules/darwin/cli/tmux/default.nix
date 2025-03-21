{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.tmux;
in
{
  options.shiro.cli.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to install tmux";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tmux ];

    programs.tmux = {
      enable = true;

      # plugins = with pkgs; [
      #   tmuxPlugins.sensible
      #   tmuxPlugins.resurrect
      #   tmuxPlugins.continuum
      #   tmuxPlugins.vim-tmux-navigator
      # ];

      extraConfig = ''
        set -g default-terminal "screen-256color"

        # Set prefix to Ctrl+Space
        unbind C-b
        set -g prefix C-Space
        bind-key C-Space send-prefix

        # Set split windows | and -
        unbind %
        bind | split-window -h

        unbind '"'
        bind - split-window -v

        # Reload config by pressing r
        unbind r
        bind r source-file ~/.tmux.conf

        # Resize panes with vim-like binding
        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5
        bind -r h resize-pane -L 5

        bind -r m resize-pane -Z

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Enable mouse mode
        set -g mouse on

        set-window-option -g mode-keys vi

        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection

        unbind -T copy-mode-vi MouseDragEnd1Pane

        # tpm plugin
        set -g @plugin 'tmux-plugins/tpm'

        # list of tmux plugins
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'christoomey/vim-tmux-navigator' # for navigating panes and vim/nvim with Ctrl-hjkl
        set -g @plugin 'tmux-plugins/tmux-resurrect' # persist tmux sessions after computer restart
        set -g @plugin 'tmux-plugins/tmux-continuum' # automatically saves sessions for you every 15 minutes

        set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
        set -g @catppuccin_date_time "%d.%m.%Y %H:%M"

        set -g @resurrect-capture-pane-contents 'on' # allow tmux-ressurect to capture pane contents
        set -g @continuum-restore 'on' # enable tmux-continuum functionality

        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'
      '';
    };
  };
}
