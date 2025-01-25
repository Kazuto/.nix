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

  extraOptions = {
    home.configFile."tmux/tmux.conf".source = ./tmux.conf;
  };

  output = {
    home.packages = with pkgs; [ tmux ];
  };
}
