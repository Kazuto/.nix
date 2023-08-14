{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.cli.codespell;
in
{
  options.shiro.cli.codespell = with types; {
    enable = mkBoolOpt false "Whether or not to install Codespell";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ codespell ];
  };
}
