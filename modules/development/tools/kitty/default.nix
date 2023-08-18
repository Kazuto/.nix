{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.tools.kitty;
in
{
  options.shiro.development.tools.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to install Kitty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kitty ];

    shiro.home.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };
}


