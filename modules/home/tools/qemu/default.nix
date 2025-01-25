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
    "tools"
    "qemu"
  ];

  output = {
    environment.systemPackages = with pkgs; [ qemu-kvm virt-manager ];
  };
}
