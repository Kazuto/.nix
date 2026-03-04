{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.prismlauncher;
in
{
  options.shiro.apps.prismlauncher = with types; {
    enable = mkBoolOpt false "Whether or not to install prismlauncher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ prismlauncher ];
  };
}
