{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.services.openssh;
in
{
  options.shiro.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure ssh settings.";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}


