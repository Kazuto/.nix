{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.tools.insomnia;
in
{
  options.shiro.development.tools.insomnia = with types; {
    enable = mkBoolOpt false "Whether or not to install Insomnia.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ insomnia ];
  };
}


