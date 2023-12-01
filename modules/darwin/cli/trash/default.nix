{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.trash;
in
{
  options.shiro.cli.trash = with types; {
    enable = mkBoolOpt false "Whether or not to install trash";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ darwin.trash ];

    shiro.home.extraOptions = {
      programs.zsh.shellAliases.rm = "trash";
    };
  };
}
