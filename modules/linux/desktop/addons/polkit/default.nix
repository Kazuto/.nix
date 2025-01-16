{ options, config, lib, pkgs, namespace, ... }:

with lib;
let
  cfg = config.${namespace}.desktop.addons.polkit;
in
{
  options.${namespace}.desktop.addons.polkit = with types; {
    enable = mkBoolOpt false "Whether or not to install polkit.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ polkit_gnome ];

    environment.sessionVariables = {
      POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };
}
