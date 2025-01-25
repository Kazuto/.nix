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

  networking.hostName = "susanoo";

  shiro = {
    nix = enabled;

    apps = {
      bitwarden = enabled;
      firefox = enabled;
      vlc = enabled;
    };

    cli = {
      flake = enabled;
      btop = enabled;
      curl = enabled;
      neofetch = enabled;
      neovim = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    hardware = {
      audio = enabled;
      network = enabled;
    };

    services = {
      openssh = enabled;
      printing = enabled;
      dbus = enabled;
    };

    system = {
      boot = enabled;
      env = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };

    tools = {
      git = enabled;
      ghostty = enabled;
    };
  };

  system.stateVersion = "24.11";
}
