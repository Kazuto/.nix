{ config, pkgs, home-manager, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    <home-manager/nixos>
  ];

  # === Bootloader === #

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };

    efi.canTouchEfiVariables = true;
  };

  # === Connectivity === #

  networking = {
    hostName = "amaterasu";

    networkmanager.enable = true;
  };

  hardware.bluetooth.enable = true;

  # === Input and Output === #

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable OpenGL
  hardware.opengl.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "mac_nodeadkeys";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable the displaying of notifications
  services.dbus.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # === Locale === #

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # === Display and Tiling === #

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      sddm.enable = true;

      # Enable automatic login for the user.
      autoLogin = {
        enable = true;
        user = "kazuto";
      };
    };
  };

  environment.sessionVariables = {
    # If you cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";

    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # === Users and Home Manager === #

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    kazuto = {
      isNormalUser = true;
      description = "Kazuto";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  home-manager.users.kazuto = import ./home.nix;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # === Packages === #

  nixpkgs = {
    # You can add overlays here
    overlays = [];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # === Security === #

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # === System === #

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
