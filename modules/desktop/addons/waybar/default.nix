{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.desktop.addons.waybar;
in
{
  options.shiro.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Whether or not to install waybar.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar playerctl inotify-tools];

    shiro.home.configFile."waybar".source = ./config;

    nixpkgs.overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oa: {
          mesonFlags = oa.mesonFlags ++ [ "-Dexperimental=true" ];
          patches = (oa.patches or []) ++ [
            (pkgs.fetchpatch {
              name = "fix waybar hyprctl";
              url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
              sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
            })
          ];
        });
      })
    ];
  };
}



