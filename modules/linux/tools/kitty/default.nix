{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.kitty;
in
{
  options.${namespace}.tools.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to install Kitty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kitty ];

    shiro.home.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };
}


