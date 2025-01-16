{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.apps.prismlauncher;
in
{
  options.${namespace}.apps.prismlauncher = with types; {
    enable = mkBoolOpt false "Whether or not to install prismlauncher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ prismlauncher ];
  };
}
