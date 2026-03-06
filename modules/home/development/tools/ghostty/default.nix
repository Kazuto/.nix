{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.ghostty;
in
{
  options.shiro.development.tools.ghostty = with types; {
    enable = mkBoolOpt false "Whether or not to install ghostty.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ (if stdenv.isDarwin then ghostty-bin else ghostty) ];

    xdg.configFile."ghostty/config".text = ''
      cursor-style = block

      font-size = 16
      font-family = "JetBrainsMono NFM Regular"

      ${optionalString pkgs.stdenv.isDarwin "macos-titlebar-style = hidden"}

      scrollback-limit = 1000

      theme = catppuccin-mocha

      window-padding-x = 10
      window-padding-y = 10,0
      window-padding-color = extend

      confirm-close-surface = false

      # Keybinds
      keybind = ctrl+g>r=reload_config

      # Creating splits
      keybind = ctrl+g>h=new_split:left
      keybind = ctrl+g>j=new_split:down
      keybind = ctrl+g>k=new_split:up
      keybind = ctrl+g>l=new_split:right

      keybind = ctrl+g>f=toggle_split_zoom
      keybind = ctrl+g>x=close_surface

      # Resizing splits
      keybind = ctrl+g>shift+h=resize_split:left,10
      keybind = ctrl+g>shift+j=resize_split:down,10
      keybind = ctrl+g>shift+k=resize_split:up,10
      keybind = ctrl+g>shift+l=resize_split:right,10
      keybind = ctrl+g>shift+e=equalize_splits

      # Navigating splits
      keybind = ctrl+h=goto_split:left
      keybind = ctrl+j=goto_split:bottom
      keybind = ctrl+k=goto_split:top
      keybind = ctrl+l=goto_split:right
    '';

    xdg.configFile."ghostty/themes/catppuccin-mocha".text = ''
      palette = 0=#45475a
      palette = 1=#f38ba8
      palette = 2=#a6e3a1
      palette = 3=#f9e2af
      palette = 4=#89b4fa
      palette = 5=#f5c2e7
      palette = 6=#94e2d5
      palette = 7=#a6adc8
      palette = 8=#585b70
      palette = 9=#f38ba8
      palette = 10=#a6e3a1
      palette = 11=#f9e2af
      palette = 12=#89b4fa
      palette = 13=#f5c2e7
      palette = 14=#94e2d5
      palette = 15=#bac2de
      background = 1e1e2e
      foreground = cdd6f4
      cursor-color = f5e0dc
      cursor-text = 1e1e2e
      selection-background = 353749
      selection-foreground = cdd6f4
    '';
  };
}
