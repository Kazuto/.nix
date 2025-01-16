{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.development.languages.go;
in
{
  options.${namespace}.development.languages.go = with types; {
    enable = mkBoolOpt false "Whether or not to use Golang";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      pkgs.go
    ];
  };
}
