{ lib, config, ... }:

let
  cfg = config.shiro.apps.firefox;
in
{
  options.shiro.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to install firefox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox ];
  };
}
