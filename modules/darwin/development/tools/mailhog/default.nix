{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.mailhog;
in
{
  options.shiro.development.tools.mailhog = with types; {
    enable = mkBoolOpt false "Whether or not to install mailhog.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mailhog ];
  };
}


