{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.cli.fd;
in
{
  options.shiro.cli.fd = with types; {
    enable = mkBoolOpt false "Whether or not to install fd";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fd ];
  };
}
