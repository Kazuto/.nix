{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.aerospace;

  padding = 14;
in
{
  options.shiro.tools.aerospace = with types; {
    enable = mkBoolOpt false "Whether or not to install aerospace";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ aerospace];

    services.jankyborders = {
      enable = true;
      package = pkgs.jankyborders;

      active_color = "0xFFFAB387";
      width = 8.0;
    };

    services.aerospace = {
      # enable = true;
      package = pkgs.aerospace;
    };
  };
}
