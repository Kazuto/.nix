{ pkgs, lib, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  shiro = {
    suites = {
      common = enabled;
    };

    cli = {
      bat = enabled;
      btop = enabled;
      curl = enabled;
      eza = enabled;
      fzf = enabled;
      gh = enabled;
      git = enabled;
      neovim = enabled;
      ripgrep = enabled;
      tmux = enabled;
      wget = enabled;
      zoxide = enabled;
    };

    tools = {
      docker = enabled;
    };

    development = {
      tools = {
        opencode = enabled;
      };
    };

    services = {
      samba = {
        enable = true;
        shares = {
          Media = {
            path = "/mnt/media";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
          };
          Shows = {
            path = "/mnt/shows";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
          };
          Storage = {
            path = "/mnt/storage";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
          };
          Backup = {
            path = "/mnt/backup";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
          };
        };
      };
    };
  };

  networking.hostName = "izanagi";

  system.stateVersion = "24.11";
}
