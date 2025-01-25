{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "hardware"
    "audio"
  ];

  output = {
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


