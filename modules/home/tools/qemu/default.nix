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
    home.packages = with pkgs; [ qemu-kvm virt-manager ];
  };
}
