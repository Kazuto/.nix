{ lib, config, ... }:

let
  cfg = config.shiro.apps.teams;
in
{
  options.shiro.apps.teams = with types; {
    enable = mkBoolOpt false "Whether or not to install Teams";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ teams ];
  };
}
