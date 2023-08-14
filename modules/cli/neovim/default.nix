{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.cli.neovim;
in
{
  options.shiro.cli.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to install neovim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neovim vimPlugins.codeium-vim ];

    environment.variables = {
      EDITOR = "nvim";
    };

    shiro.cli.fzf = enabled;

    shiro.home.configFile."nvim".source = ./config;

    shiro.home.extraOptions = {
      programs.zsh.shellAliases.vim = "nvim";
      programs.bash.shellAliases.vim = "nvim";
    };
  };
}
