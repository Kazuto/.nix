{ lib, config, ... }:

let
  cfg = config.shiro.apps.bitwarden;
in
{
  options.shiro.apps.bitwarden = with types; {
    enable = mkBoolOpt false "Whether or not to install bitwarden";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bitwarden ];
  };
}
