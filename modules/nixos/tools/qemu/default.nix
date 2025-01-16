{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.qemu;
in
{
  options.${namespace}.tools.qemu = with types; {
    enable = mkBoolOpt false "Whether or not to install qemu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ qemu-kvm virt-manager ];
  };
}
