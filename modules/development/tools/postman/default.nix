{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.tools.postman;
in
{
  options.shiro.development.tools.postman = with types; {
    enable = mkBoolOpt false "Whether or not to install Postman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ postman ];
  };
}


