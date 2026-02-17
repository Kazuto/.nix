{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.opencode;
in
{
  options.shiro.development.tools.opencode = with types; {
    enable = mkBoolOpt false "Whether or not to install opencode";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ opencode ];
  };
}
