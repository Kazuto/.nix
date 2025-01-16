{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.firefox;
in
{
  options.${namespace}.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to install firefox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox ];
  };
}
