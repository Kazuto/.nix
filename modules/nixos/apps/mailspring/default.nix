{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.mailspring;
in
{
  options.${namespace}.apps.mailspring = with types; {
    enable = mkBoolOpt false "Whether or not to install Mailspring";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mailspring ];
  };
}
