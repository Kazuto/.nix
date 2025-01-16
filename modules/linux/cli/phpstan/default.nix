{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli.phpstan;
in
{
  options.${namespace}.cli.phpstan = with types; {
    enable = mkBoolOpt false "Whether or not to install phpstan";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ php81Packages.phpstan ];
  };
}
