{ lib, config, ... }:

let
  cfg = config.shiro.apps.mailspring;
in
{
  options.shiro.apps.mailspring = with types; {
    enable = mkBoolOpt false "Whether or not to install Mailspring";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mailspring ];
  };
}
