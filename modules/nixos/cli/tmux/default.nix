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
    "cli"
    "tmux"
  ];

  output = {
    environment.systemPackages = with pkgs; [ tmux ];

    shiro.home.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };
}
