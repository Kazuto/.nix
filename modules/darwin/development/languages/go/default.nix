{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.go;
in
{
  options.shiro.development.languages.go = with types; {
    enable = mkBoolOpt false "Whether or not to use Golang";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      go
      gotools
      golangci-lint
      ginkgo
      mockgen
    ];
  };
}
