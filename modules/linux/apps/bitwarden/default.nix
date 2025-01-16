{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.bitwarden;
in
{
  options.${namespace}.apps.bitwarden = with types; {
    enable = mkBoolOpt false "Whether or not to install bitwarden";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bitwarden ];
  };
}
