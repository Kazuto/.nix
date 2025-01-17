{ options, config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
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
