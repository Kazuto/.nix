{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.audio;
in
{
  options.${namespace}.hardware.audio = with types; {
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


