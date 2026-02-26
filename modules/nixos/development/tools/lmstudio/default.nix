{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.lmstudio;
in
{
  options.shiro.development.tools.lmstudio = with types; {
    enable = mkBoolOpt false "Whether or not to install LM Studio.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ lmstudio ];
  };
}
