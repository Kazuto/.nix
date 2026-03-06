{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.claude-code;
in
{
  options.shiro.development.tools.claude-code = with types; {
    enable = mkBoolOpt false "Whether or not to install claude code.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ claude-code ];
  };
}
