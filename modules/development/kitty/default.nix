{ lib, config, ... }:

let
  cfg = config.shiro.development.kitty;
in
{
  options.shiro.development.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to install Kitty.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kitty ];
  };
}


