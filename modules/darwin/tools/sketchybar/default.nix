{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.tools.sketchybar;
in
{
  options.shiro.tools.sketchybar = with types; {
    enable = mkBoolOpt false "Whether or not to install sketchybar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sketchybar
      lua5_4
      sbarlua
      switchaudio-osx
      nowplaying-cli
    ];

    fonts.packages = with pkgs; [
      sketchybar-app-font
    ];

    services.sketchybar = {
      enable = true;
      package = pkgs.sketchybar;
    };

    # Symlink sbarlua into a stable home path so lua5.4 can find it.
    # nix-darwin does not expose lib/ directories via /run/current-system/sw.
    shiro.home.file.".local/share/sketchybar_lua/sketchybar.so".source =
      "${pkgs.sbarlua}/lib/lua/5.4/sketchybar.so";
  };
}
