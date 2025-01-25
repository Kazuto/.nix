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
    "services"
    "openssh"
  ];

  output = {
    services.openssh.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}


