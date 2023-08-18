{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.tools.valet-linux;
in
{
  options.shiro.development.tools.valet-linux = with types; {
    enable = mkBoolOpt false "Whether or not to install Beekeeper Studio.";
  };

  config = mkIf cfg.enable {
    shiro.development.languages.php81 = enabled;

    environment.systemPackages = with pkgs; [ dnsmasq nginx mysql ];

    services.nginx = enabled;
  };
}
