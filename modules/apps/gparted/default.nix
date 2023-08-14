{ lib, config, ... }:

let
  cfg = config.shiro.apps.gparted;
in
{
  options.shiro.apps.gparted = with types; {
    enable = mkBoolOpt false "Whether or not to install gparted";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gparted ];
  };
}
