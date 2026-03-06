{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.kitty;
in
{
  options.shiro.development.tools.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to install Kitty.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kitty ];
  };
}
