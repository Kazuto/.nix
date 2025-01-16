{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.boot;
in
{
  options.shiro.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to configure boot loader.";
  };

  config = mkIf cfg.enable {
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.systemd-boot.configurationLimit = 5;
    # boot.loader.efi.canTouchEfiVariables = true;

    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    # boot.loader.systemd-boot.editor = false;

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

  };
}

