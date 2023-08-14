{ lib, config, ... }:

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

    shiro.home = {
      extraOptions = {
        programs.zsh.shellAliases.vim = "nvim";
        programs.bash.shellAliases.vim = "nvim";
      };
    };
  };
}
