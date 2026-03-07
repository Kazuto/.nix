{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.apps.spotify;
in
{
  options.shiro.apps.spotify = with types; {
    enable = mkBoolOpt false "Whether or not to install Spotify";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (pkgs.symlinkJoin {
        name = "spotify";
        paths = [ spotify ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/spotify \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      })
      spicetify-cli
    ];
  };
}
