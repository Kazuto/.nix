{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.services.samba;
in
{
  options.shiro.services.samba = with types; {
    enable = mkBoolOpt false "Whether or not to enable Samba file sharing";
    shares = mkOpt (attrsOf (attrsOf str)) { } "Samba share definitions";
  };

  config = mkIf cfg.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = cfg.shares;
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
