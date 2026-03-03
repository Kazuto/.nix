{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.golangci-lint;
in
{
  options.shiro.development.tools.golangci-lint = with types; {
    enable = mkBoolOpt false "Whether or not to install golangci-lint.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ golangci-lint ];
  };
}
