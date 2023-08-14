{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.shiro.tools.qemu;
in
{
  options.shiro.tools.qemu = with types; {
    enable = mkBoolOpt false "Whether or not to install qemu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ qemu-kvm virt-manager ];
  };
}
