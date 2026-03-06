{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.weave;
in
{
  options.shiro.cli.weave = with types; {
    enable = mkBoolOpt false "Whether or not to install weave";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.shiro.weave ];
  };
}
