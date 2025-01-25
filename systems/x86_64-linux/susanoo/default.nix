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
    home = enabled;
    bootloader = enabled;
    environment = enabled;
    fonts = enabled;
    locale = enabled;
    networking = enabled;
  };

  # Audio
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
    pipewire
    pulseaudioFull
    wireplumber
  ];

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  # Input (Keyboard)
  console.useXkbConfig = true;

  services.xserver = {
    xkb.layout = "de";
    # xkbVariant = "mac_nodeadkeys";
  };

  # Locale and Time
  time.timeZone = "Europe/Berlin";

  # Networking
  networking.hostName = "susanoo";
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
  };

  # Printing
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cups-kyodialog ];
    };
  };
  
  system.stateVersion = "24.11";
}
