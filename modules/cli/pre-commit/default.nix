{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.pre-commit;
in
{
  options.shiro.cli.pre-commit = with types; {
    enable = mkBoolOpt false "Whether or not to install pre-commit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pre-commit ];
  };
}
