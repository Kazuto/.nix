{ options, config, lib, pkgs, stdenv, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.hyprload;

  hyprload = stdenv.mkDerivation {
    name = "hyprload";
    src = fetchFromGitHub {
        owner = "Duckonaut";
        repo = "hyprload";
        rev = "cdec6d114143d6ee95fd77683e494ab65fb74351";
        sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };

    installPhase = ''
      ./install.sh
    '';
  };
in
{
  options.shiro.desktop.addons.hyprload = with types; {
    enable = mkBoolOpt false "Whether or not to install hyprload.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ hyprload ];

    shiro.home.configFile."hypr/hyprload.toml".source = ./hyprload.toml;
  };
}



