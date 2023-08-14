{ lib, config, ... }:

let
  cfg = config.shiro.development.postman;
in
{
  options.shiro.development.postman = with types; {
    enable = mkBoolOpt false "Whether or not to install Postman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ postman ];
  };
}


