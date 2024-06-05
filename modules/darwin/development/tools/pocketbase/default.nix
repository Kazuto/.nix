{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.pocketbase;
in
{
  options.shiro.development.tools.pocketbase = with types; {
    enable = mkBoolOpt false "Whether or not to install pocketbase";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pocketbase ];
  };
}
