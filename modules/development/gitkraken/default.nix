{ lib, config, ... }:

let
  cfg = config.shiro.development.gitkraken;
in
{
  options.shiro.development.gitkraken = with types; {
    enable = mkBoolOpt false "Whether or not to install Gitkraken.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gitkraken ];
  };
}


