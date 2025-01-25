{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "suites"
    "common"
  ];

  output = {
    shiro = {
      cli = {
        btop = enabled;
      	curl = enabled;
        neofetch = enabled;
        neovim = enabled;
        # wget = enabled;
        zsh = enabled;
      };

      tools = {
        ghostty = enabled;
      };
    };
  };
}
