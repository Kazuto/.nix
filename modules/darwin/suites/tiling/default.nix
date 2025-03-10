{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.suites.tiling;
in
{
  options.shiro.suites.tiling = with types; {
    enable = mkBoolOpt false "Whether or not to enable tiling configuration.";
  };

  config = mkIf cfg.enable {
    shiro = {
      tools = {
        aerospace = enabled;
        # yabai = enabled;
        # skhd = enabled;
        # spacebar = enabled;
        sketchybar = enabled;
      };
    };
  };
}
