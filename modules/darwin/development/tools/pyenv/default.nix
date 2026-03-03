{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.pyenv;
in
{
  options.shiro.development.tools.pyenv = with types; {
    enable = mkBoolOpt false "Whether or not to install pyenv.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pyenv ];
  };
}
