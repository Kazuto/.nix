{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.phpstan;
in
{
  options.shiro.cli.phpstan = with types; {
    enable = mkBoolOpt false "Whether or not to install phpstan";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ php81Packages.phpstan ];
  };
}
