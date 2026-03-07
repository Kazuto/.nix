{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.security.yubikey;
in
{
  options.shiro.security.yubikey = with types; {
    enable = mkBoolOpt false "Whether to enable YubiKey authentication";
  };

  config = mkIf cfg.enable {
    # Install YubiKey packages
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubico-pam
      pam_u2f
    ];

    # Enable U2F support
    hardware.gpgSmartcards.enable = true;

    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    # Configure PAM for YubiKey authentication
    security.pam.services = {
      # Sudo with YubiKey
      sudo = {
        u2fAuth = true;
        sshAgentAuth = true;
      };

      # Login with YubiKey (for greetd/display manager)
      greetd = {
        u2fAuth = true;
      };

      # Polkit with YubiKey (for privilege escalation in GUI)
      polkit-1 = {
        u2fAuth = true;
      };
    };

    security.pam.u2f = {
      enable = true;
      control = "sufficient";  # YubiKey OR password (not both)
      cue = true;  # Prompt to touch the key
    };

    # Polkit rules for YubiKey
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
