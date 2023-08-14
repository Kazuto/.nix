{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.skeema;
in
{
  options.shiro.cli.skeema = with types; {
    enable = mkBoolOpt false "Whether or not to install skeema";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ skeema ];
  };
}
