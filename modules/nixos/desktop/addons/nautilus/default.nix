{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.nautilus;
in
{
  options.shiro.desktop.addons.nautilus = with types; {
    enable = mkBoolOpt false "Whether or not to install Nautilus.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      sushi
    ];
  };
}
