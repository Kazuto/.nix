{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.bun;
in
{
  options.shiro.development.tools.bun = with types; {
    enable = mkBoolOpt false "Whether or not to install bun";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bun ];
  };
}
