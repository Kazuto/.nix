{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = with types; {
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


