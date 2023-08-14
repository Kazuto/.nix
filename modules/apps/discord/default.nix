{ lib, config, ... }:

let
  cfg = config.shiro.apps.discord;
in
{
  options.shiro.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to install Discord";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
