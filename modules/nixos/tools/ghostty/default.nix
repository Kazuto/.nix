{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.ghostty;
in
{
  options.${namespace}.tools.ghostty = with types; {
    enable = mkBoolOpt false "Whether or not to install Ghostty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ghostty ];
  };
}


