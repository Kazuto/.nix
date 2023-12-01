{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.gitleaks;
in
{
  options.shiro.cli.gitleaks = with types; {
    enable = mkBoolOpt false "Whether or not to install gitleaks";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gitleaks ];
  };
}
