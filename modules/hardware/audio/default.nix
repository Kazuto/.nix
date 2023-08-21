{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.hardware.audio;
in
{
  options.shiro.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to configure audio settings.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    # Enable sound with pipewire.
    # sound.enable = true;

    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    hardware.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      pamixer
      pavucontrol
      pipewire
      pulseaudioFull
      wireplumber
    ];

    shiro.user.extraGroups = [ "audio" ];
  };
}


