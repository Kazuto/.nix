{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.system.env;
in
{
  options.shiro.system.env = with types; {
    enable = mkBoolOpt false "Whether or not to set xdg environment variables.";
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
      };
    };
  };
}

