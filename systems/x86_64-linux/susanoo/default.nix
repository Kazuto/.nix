{ 
    pkgs, 
    lib, 
    namespace,
    ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    bootloader = enabled;
    environment = enabled;
    fonts = enabled;
    locale = enabled;
    networking = enabled;
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
    pipewire
    pulseaudioFull
    wireplumber
  ];

  hardware.pulseaudio.enable = false;

  networking.hostName = "susanoo";
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.rtkit.enable = true;

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };
    
    printing = {
      enable = true;
      drivers = [ pkgs.cups-kyodialog ];
    };

    xserver = {
      layout = "de";
      # xkbVariant = "mac_nodeadkeys";
    };
  };
  

  system.stateVersion = "24.11";

  time.timeZone = "Europe/Berlin";
}
