{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.insomnia;
in
{
  options.shiro.development.insomnia = with types; {
    enable = mkBoolOpt false "Whether or not to install Insomnia.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ insomnia ];
  };
}


